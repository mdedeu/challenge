// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/ownership/Ownable.sol";

//TO-DO instead of owner, implement roles

contract ETHPool is Ownable {

    address[] stakeHolders;
    mapping(address => uint) balances;

    function depositRewards() public onlyOwner payable{


    }

    function withdraw() public{

    }

    function deposit() public payable {

    }

    function calculateRewards() private view {

    }
}