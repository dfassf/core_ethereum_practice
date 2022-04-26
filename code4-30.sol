pragma solidity >0.4.16;

interface token {
    // 컨트랙트 간 상속 구조 선언, 블록체인 상 컨트랙트 주소에서 컨트랙트 인터페이스 생성
    function transfer(address receiver, uint amount);
}

contract CrowdFund{
    address public beneficiary;
    uint public fundingGoal;
    uint public amountRaised;
    uint public deadline;
    uint public price;
    // tokenReward를 token의 인터페이스로 선언
    // * 인터페이스 유의사항
    // 함수 구현 x
    // 다른 컨트랙트나 인터페이스 상속 x
    // 생성자, 상태변수 정의 x
    // 스트럭트와 이넘 x -> 지금은 되는 듯?
    token public tokenReward;
    mapping(address => uint256) public balanceOf;
    bool public fundingGoalReached = false;
    bool public crowdsaleClosed = false;

    event GoalReached(address beneficiaryAddress, uint amountRaisedValue);
    event FundTransfer(address backer, uint amount, bool isContribution);

    function CrowdFund(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint etherCostoOfEachToken,
        address addressOfTokenUsedAsReward
    ) public {
        beneficiary = ifSuccessfulSendTo;
        // 이 아래 것들이 라이브러리라는건가?
        fundingGoal = fundingGoalInEthers * 1 ether;
        deadline = now + durationInMinutes * 1 minutes;
        price = etherCostOfEachToken * 1 ether;
        tokenReward = token(addressofTokenUsedAsReward);
    }

    function () external payable {
        require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount / price);
        emit FundTransfer(msg.sender, amount, true);
    }

    modifier afterDeadline() { if(now >= deadline) _;}

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
                if(msg.sender.send(amount)) {
                    FundTransfer(msg.sender, amount, false);
                } else {
                    balanceOf[msg.sender] = amount;
                }
            }
        }
        if(fundingGoalReached && beneficiary == msg.sender) {
            if(beneficiary.send(amountRaised)) {
                emit FundTransfer(beneficiary, amountRaised, false);
            } else {
                fundingGoalReached = false;
            }
        }
    }

}