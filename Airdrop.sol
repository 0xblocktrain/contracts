// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop {
    constructor() {}

    function bulkAirdropERC721(IERC721 _token, address[] calldata _to, uint256[] calldata _id) public {
        require(_to.length == _id.length, "Token ID's don't match the number of receivers");
        for(uint256 i = 0; i < _to.length; i++) {
            _token.safeTransferFrom(msg.sender, _to[i], _id[i]);
        }
    }

    function bulkAirdropERC1155(IERC1155 _token, address[] calldata _to, uint256[] calldata _id, uint256[] calldata _amount) public {
        require(_to.length == _id.length, "Token ID's don't match the number of receivers");
        require(_to.length == _amount.length, "Amount array doesn't match the number of receivers");
        for(uint256 i = 0; i < _to.length; i++) {
            _token.safeTransferFrom(msg.sender, _to[i], _id[i], _amount[i], "");
        }
    }

    function bulkAirdropERC20(IERC20 _token, address[] calldata _to, uint256[] calldata _amount) public {
        require(_to.length == _amount.length, "Amount doesn't match the number of receivers");
        for(uint256 i = 0; i < _to.length; i++) {
            _token.transferFrom(msg.sender, _to[i], _amount[i]);
        }
    }
}