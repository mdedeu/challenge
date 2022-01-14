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
        require(totalBalance > 0  && msg.value >= totalBalance);
        total_rewards += (msg.value / total_balance);
        total_balance += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        uint256 amount = balances[msg.sender] + balances[msg.sender] * (total_rewards - rewards_when_deposited[msg.sender]);
        balances[msg.sender] = 0;
        totalBalance-= amount;
        payable(msg.sender).transfer(amount);
        
    } 

    function deposit() public payable {
        rewards_when_deposited[msg.sender] = total_rewards;
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
    }
}
