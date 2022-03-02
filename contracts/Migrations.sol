//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Migrations {
  address public owner;
  uint public lastCompleted;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  constructor() {
    owner = msg.sender;
  }

  function setCompleted(uint completed) public restricted {
    lastCompleted = completed;
  }

  function upgrade(address newAddress) public restricted {
    Migrations upgraded = Migrations(newAddress);
    upgraded.setCompleted(lastCompleted);
  }
}
