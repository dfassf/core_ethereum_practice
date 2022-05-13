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
/*

The following syntax is deprecated: 
f.gas(...)(), f.value(...)() and (new C).value(...)().  

Replace these calls by
f{gas: ..., value: ...}() and (new C){value: ...}(). 

 */
        // if(msg.sender.call )
        // if(msg.sender.call.value(amountToWithdraw)() == false) { // 0.8 에선 오류..
        if(msg.sender.call{value:amountToWithdraw}("") == false){
            revert();
        }
        balanceOf[msg.sender] = 0;
    }
}