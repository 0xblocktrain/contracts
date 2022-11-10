// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";

contract Bank {
    mapping (address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // function withdraw() nonReentrant external {
    function withdraw() external {
        uint256 bal = balances[msg.sender];

        require(bal > 0, "Balance is 0");

        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Failed to withdraw");

        balances[msg.sender] = 0;
    }
}