//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Base.sol";
import "./Ownable.sol";
import "./Validatable.sol";

contract Contract is Ownable, Validatable {

    function getBalance () public isOwner view returns (uint256) {
        return address(this).balance;
    }

    function newAgreement (address _tenant, address _landlord, string memory _propertyAddress, uint256 _startBlock, uint256 _endBlock, uint256 _amount) 
    public returns (uint) {
        id = id + 1;
        Agreement memory agreement = Agreement(_tenant, _landlord, _propertyAddress, _startBlock, _endBlock, _amount, 0, AgreementStatus.Pending);
        validateNewAgreement(agreement);
        agreements[id] = agreement;
        return id;
    }

    function getAgreement (uint _id) public
    isLandlordOrTenantOrOwner(_id)  
    view returns (uint, address, address, string memory, uint256, uint256, uint256, uint256, AgreementStatus) {
        Agreement memory agreement = agreements[_id];
        return (
            id, 
            agreement.tenant, 
            agreement.landlord, 
            agreement.propertyAddress, 
            agreement.startBlock,
            agreement.endBlock,
            agreement.amount,
            agreement.balance,
            agreement.status
        );
    }

    function payAgreement (uint _id) public isTenantOrOwner(_id) isStatus(_id, AgreementStatus.Pending) payable returns (bool)  {
        require(msg.value > 0, "Can't pay zero");
        Agreement storage agreement = agreements[_id];
        require(msg.value + agreement.balance <= agreement.amount, "Can't over pay");
        agreement.balance = agreement.balance + msg.value;
        agreement.status = agreement.balance == agreement.amount ? AgreementStatus.Paid : AgreementStatus.Pending;
        return true;
    }

    function payLandlord (uint _id) public isTenantOrOwner(_id) canFinalise(_id) returns (uint) {
        Agreement storage agreement = agreements[_id];
        require(block.number  >= agreement.endBlock, "Agreement ended");
        payable(agreement.landlord).transfer(agreement.balance);
        agreement.status = AgreementStatus.Complete;
        agreement.balance = 0;
        return block.number;
    }

}