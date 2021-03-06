//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Base.sol";

contract Ownable is Base {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() {
    owner = msg.sender;
  }

  modifier isOwner() {
    require(msg.sender == owner, "not owner");
    _;
  }

  modifier isTenant(uint _id) {
      Agreement storage agreement = agreements[_id];
      require(msg.sender == agreement.tenant, "not tenant");
      _;
  }

  modifier isTenantOrOwner(uint _id) {
      Agreement storage agreement = agreements[_id];
      require(msg.sender == agreement.tenant || msg.sender == owner, "not tenant or owner");
      _;
  }

  modifier isLandlord(uint _id) {
      Agreement storage agreement = agreements[_id];
      require(msg.sender == agreement.landlord, "not landlord");
      _;
  }

  modifier isLandlordOrOwner(uint _id) {
      Agreement storage agreement = agreements[_id];
      require(msg.sender == agreement.landlord || msg.sender == owner, "not landlord or owner");
      _;
  }

  modifier isLandlordOrTenant(uint _id) {
      Agreement storage agreement = agreements[_id];
      require(msg.sender == agreement.landlord || msg.sender == agreement.tenant, "not landlord or tenant");
      _;
  }

  modifier isLandlordOrTenantOrOwner(uint _id) {
      Agreement storage agreement = agreements[_id];
      require(
        msg.sender == agreement.landlord || msg.sender == agreement.tenant || msg.sender == owner,
        "not landlord, tenant or owner"
      );
      _;
  }

  function transferOwnership(address newOwner) public isOwner {
    require(newOwner != address(0), "already owner");
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}
