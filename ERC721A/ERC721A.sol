// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";

contract PolyDape is ERC721A {

    uint256 TOTAL_SUPPLY = 500;
    uint256 MAX_MINTS = 69;

    string public baseURI = "ipfs://QmZUmkiC9jmMEhQUmRHdf4Bi9EVHfvzNHCJE91d54svWMd/";

    constructor() ERC721A("PolyDape", "PDN") {}

    function mint(uint256 quantity) external {
        require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeded the limit");
        require(totalSupply() + quantity <= TOTAL_SUPPLY, "Not enough tokens left");
        _safeMint(msg.sender, quantity);
    }
    
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

}