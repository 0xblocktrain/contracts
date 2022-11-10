// Link to blog - https://www.blocktrain.info/blog/create-an-nft-collection-with-on-chain-metadata
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicSVG is ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping (uint256 => string) private _tokenURIs;

    event NFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("DynamicSVG", "DSN") {}

    // Array of names
    string[] onepiece = ['Luffy', 'Zoro', 'Shanks', 'Ace', 'Whitebeard', 'Aokiji', 'Garp', 'Blackbeard', 'Kaido', 'Sanji'];
    string[] naruto = ['Naruto', 'Sasuke', 'Kakashi', 'Jiraiya', 'Hinata', 'Itachi', 'Orochimaru', 'Tsunade', 'Madara', 'Obito'];
    string[] aot = ['Eren', 'Mikasa', 'Levi', 'Armin', 'Sasha','Jean', 'Braun', 'Annie', 'Connie', 'Erwin'];
    string[] mha = ['Midoriya', 'Bakugo', 'Todoroki', 'Uraraka', 'Endeavour', 'Shingaraki', 'Dabi', 'Togata', 'Lida', 'Aizawa'];

    string svgFirstPart = "<svg viewBox='0 0 350 350' xmlns='http://www.w3.org/2000/svg'><defs><linearGradient id='grad' x1='0%' y1='0%' x2='100%' y2='0%'><stop offset='0%' style='stop-color:#E0144C;stop-opacity:1' /><stop offset='100%' style='stop-color:#FF97C1;stop-opacity:1' /></linearGradient></defs><rect width='100%' height='100%' fill='url(#grad)'/><text fill='white' style='font-size: 20px' x='15%' y='10%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgSecondPart = "</text><text fill='white' style='font-size: 20px' x='15%' y='18%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgThirdPart = "</text><text fill='white' style='font-size: 20px' x='15%' y='26%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgFourthPart = "</text><text fill='white' style='font-size: 20px' x='15%' y='34%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgFifthPart = "</text><text fill='white' style='font-size: 16px' x='90%' y='90%' class='base' dominant-baseline='middle' text-anchor='middle'>Rank: ";
    string svgSixthPart = "</text></svg>";

    function generateSvg(uint256 tokenId, string memory onepieceName, string memory narutoName, string memory aotName, string memory mhaName) public view returns(string memory) {
        return string(
                abi.encodePacked(
                    svgFirstPart, 
                    onepieceName, 
                    svgSecondPart, 
                    narutoName, 
                    svgThirdPart, 
                    aotName, 
                    svgFourthPart, 
                    mhaName, 
                    svgFifthPart, 
                    Strings.toString(tokenId), 
                    svgSixthPart
                )
            );
    }

    // Random One piece name
    function randomOnePieceName(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("ONE_PIECE", Strings.toString(tokenId))));

        rand = rand % onepiece.length;
        return onepiece[rand];
    }

    // Random Naruto Name
    function randomNarutoName(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("NARUTO", Strings.toString(tokenId))));

        rand = rand % naruto.length;
        return naruto[rand];
    }

    // Random AOT Name
    function randomAOTName(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("AOT", Strings.toString(tokenId))));

        rand = rand % aot.length;
        return aot[rand];
    }

    // Random MHA Name
    function randomMHAName(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("MHA", Strings.toString(tokenId))));

        rand = rand % mha.length;
        return mha[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) override internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function mintNFT() public {
        // Get token Id
        uint256 tokenId = _tokenIdCounter.current();

        string memory onepieceName = randomOnePieceName(tokenId);
        string memory narutoName = randomNarutoName(tokenId);
        string memory aotName = randomAOTName(tokenId);
        string memory mhaName = randomMHAName(tokenId);

        string memory dynamicSvg = generateSvg(tokenId, onepieceName, narutoName, aotName, mhaName);

        string memory svgBase64 = string(abi.encodePacked("data:image/svg+xml;base64,",Base64.encode(bytes(dynamicSvg))));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name" : "',
                            abi.encodePacked(onepieceName, narutoName, aotName, mhaName),
                            '","description":"My Random Anime Character List", "image":',
                            svgBase64,
                            '}'
                    )
                )
            )
        );

        string memory tokenUriBase64 = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, tokenId);
        _setTokenURI(_tokenIdCounter.current(), tokenUriBase64);

        emit NFTMinted(msg.sender, tokenId);

        _tokenIdCounter.increment();
    }
} 