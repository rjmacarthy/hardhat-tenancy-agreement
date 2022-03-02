//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Base {
    uint public id;

    enum AgreementStatus { Pending, Paid, Complete }

    struct Agreement {
        address tenant;
        address landlord;
        string propertyAddress;
        uint256 startBlock;
        uint256 endBlock;
        uint256 amount;
        uint256 balance;
        AgreementStatus status;
    }

    mapping(uint => Agreement) public agreements;
}