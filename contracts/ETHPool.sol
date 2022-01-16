// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract ETHPool is AccessControl {
    bytes32 public constant TEAM_MEMBER = keccak256("TEAM_MEMBER");

    constructor() {
        _grantRole(TEAM_MEMBER, msg.sender);
    }

    mapping(address => uint256) rewards_when_deposited;
    uint256 total_rewards;
    mapping(address => uint256) balances;
    uint256 total_balance;

    function depositRewards() public payable onlyRole(TEAM_MEMBER) {
        require(total_balance > 0);
        total_rewards += ((msg.value * 1 ether) / total_balance);
        total_balance += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        total_balance -= balances[msg.sender];
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{
            value: amount + (amount * (total_rewards - rewards_when_deposited[msg.sender])) / 1 ether
        }("");
        require(success, "Transfer failed.");
    }

    function deposit() public payable {
        rewards_when_deposited[msg.sender] = total_rewards;
        balances[msg.sender] += msg.value;
        total_balance += msg.value;
    }
}
