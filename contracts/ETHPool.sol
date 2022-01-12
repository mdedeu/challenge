// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";

//TO-DO instead of owner, implement roles

contract ETHPool is Ownable {

    address[] stakeHolders;
    mapping(address => uint) balances;

    function depositRewards() public onlyOwner payable{
      for(uint i= 0; i < stakeHolders.length; i++){
          uint percentage = balances[stakeHolders[i]] / address(this).balance;
          balances[stakeHolders[i]] += percentage * msg.value;
      }
    }
    function withdraw() public{
        require(balances[msg.sender] > 0 );
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function deposit() public payable {
        stakeHolders.push(msg.sender);
        balances[msg.sender] += msg.value;
    }
}