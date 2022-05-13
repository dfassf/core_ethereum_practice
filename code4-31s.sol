// SPDX-License-Identifier: GPL-30
pragma solidity ^0.8.1; 

contract DaoFund {
    mapping (address => uint) balanceOf;

    event WithdrawBalance (string message, uint gas);

    function getUserBalance(address user) external view returns(uint) {
        return balanceOf[user];
    }

    function addToBalance() external payable {
        balanceOf[msg.sender] = balanceOf[msg.sender] + msg.value;
    }

    function withdrawBalance() external {
            uint amountToWithdraw = balanceOf[msg.sender];
            (bool success, bytes memory data) = msg.sender.call{value: amountToWithdraw}("");
            if(!success){
                revert();
            }
        balanceOf[msg.sender] = 0;
    }
}