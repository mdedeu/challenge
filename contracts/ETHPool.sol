// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";


contract ETHPool is AccessControl {

    bytes32 public constant TEAM_MEMBER = keccak256("TEAM_MEMBER");

    constructor() {
        _grantRole(TEAM_MEMBER, msg.sender);
    }

    address[] stakeHolders;
    mapping(address => bool) exists;
    mapping(address => uint) balances;
    uint256 totalBalance; 

    function depositRewards() public  onlyRole(TEAM_MEMBER) payable{
    require(totalBalance > 0);
    for(uint i= 0; i < stakeHolders.length; i++){
          balances[stakeHolders[i]] += (msg.value * balances[stakeHolders[i]]  / totalBalance); 
    }
      totalBalance += msg.value;
    }
    function withdraw() public{
        require(balances[msg.sender] > 0 );
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function deposit() public payable {
        if(!exists[msg.sender]){
            stakeHolders.push(msg.sender);
            exists[msg.sender] = true;
        }
        balances[msg.sender] += msg.value;
        totalBalance+= msg.value;
    }
}