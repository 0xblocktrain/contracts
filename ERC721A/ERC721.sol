// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PolyDapeV2 is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("PolyDapeV2", "PDV") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmZUmkiC9jmMEhQUmRHdf4Bi9EVHfvzNHCJE91d54svWMd/";
    }

    function safeMint(uint256 quantity) public {
        require(quantity>0, "Can't mint 0 tokens");
        for(uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);
        }
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        pure
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return string(abi.encodePacked(_baseURI(), "/", Strings.toString(tokenId)));
    }
}
