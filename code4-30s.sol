// SPDX-License-Identifier: GPL-30
pragma solidity ^0.8.1; 

interface token {
    function transfer (address receiver, uint amount) external ;
}

contract CrowdFund{
    address public beneficiary;
    uint public fundingGoal;
    uint public amountRaised;
    uint public deadline;
    uint public price;
    token public tokenReward;
    mapping(address => uint256) public balanceOf;
    bool public fundingGoalReached = false;
    bool public crowdsaleClosed = false;

    event GoalReached(address beneficiaryAddress, uint amountRaisedValue);
    event FundTransfer(address backer, uint amount, bool isContribution);

    constructor(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint etherCostOfEachToken,
        address addressOfTokenUsedAsReward
    ) {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInEthers * 1 ether;
        deadline = block.timestamp + durationInMinutes * 1 minutes;
        price = etherCostOfEachToken * 1 ether;
        tokenReward = token(addressOfTokenUsedAsReward);
    }

    fallback () external payable{ 
        require(!crowdsaleClosed);
        uint amount = msg.value; 
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount / price);
        emit FundTransfer(msg.sender, amount, true);
    }

    modifier afterDeadline() { 
        if(block.timestamp >= deadline) 
        _; 
    }

    function checkGoalReached() external afterDeadline {
        if(amountRaised >= fundingGoal) {
            fundingGoalReached = true;
            emit GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }

    function safeWithdrawl() external afterDeadline {
        if(!fundingGoalReached) {
            uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if(amount > 0) {
                if(payable(msg.sender).send(amount)) {
                    emit FundTransfer(msg.sender, amount, false);
                } else {
                    balanceOf[msg.sender] = amount;
                }
            }
        }
        if(fundingGoalReached && beneficiary == msg.sender) {
            if(payable(beneficiary).send(amountRaised)) {
                emit FundTransfer(beneficiary, amountRaised, false);
            } else {
                fundingGoalReached = false;
            }
        }
    }

}