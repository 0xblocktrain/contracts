// Link to blog - https://www.blocktrain.info/course/nft-development-course/hc5E7XV0hzoThZ0N4c6W
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts@4.7.3/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";

contract EditionERC1155 is ERC1155, Ownable {

    string public name;
    string public symbol;

    uint256[] public supplies;
    uint256[] public minted;
    uint256[] public prices;

    mapping(uint => string) public tokenURI;

    constructor(uint256 _supply, uint256 _price, string memory _uri) ERC1155("") {
        name = "BlocktrainV1";
        symbol = "BVM";
        addNewEdition(_supply, _price, _uri);
    }

    function setURI(uint _id, string memory _uri) external onlyOwner {
        require(_id <= supplies.length, "Token doesn't exist");
        tokenURI[_id] = _uri;
        emit URI(_uri, _id);
    }

    function uri(uint _id) public override view returns (string memory) {
        return tokenURI[_id];
    }

    function mint(uint256 id) public payable {
        require(id < supplies.length, "Token doesn't exist");
        require(supplies[id] >= minted[id]+1, "Token supply finished");
        require(msg.value >= prices[id], "Not enough ether");

        _mint(msg.sender, id, 1, "");
        minted[id] += 1;
    }

    function addNewEdition(uint256 supply, uint256 price, string memory _uri) public onlyOwner {
        supplies.push(supply);
        minted.push(0);
        prices.push(price);
        tokenURI[supplies.length-1] = _uri;
        emit URI(_uri, supplies.length-1);
    }
}
