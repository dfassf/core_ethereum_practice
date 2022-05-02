pragma solidity ^0.4.18;

contract DaoFund {
    mapping (address => uint) balanceOf;

    event WithdrawBalance (string message, uint gas);

    function getUserBalance(address user) external view returns(uint) {
        return balanceOf[user];
    }

    funciton addToBalance() external payable {
        balanceOf[msg.sender] = balanceOf[msg.sender] + msg.value;
    }

    function withdrawBalance() external {
        uint amountToWithdraw = balanceOf[msg.sender];

        if(msg.sender.call.value(amountToWithdraw) () == false) {
            revert();
        }
        balanceOf[msg.sender] = 0;
    }
}