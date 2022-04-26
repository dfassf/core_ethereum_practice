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

    constructor(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint etherCostOfEachToken,
        address addressOfTokenUsedAsReward
    ) {
        beneficiary = ifSuccessfulSendTo;
        // 이 아래 것들이 라이브러리라는건가?
        fundingGoal = fundingGoalInEthers * 1 ether;
        // now는 이제 쓰지 않음.
        deadline = block.timestamp + durationInMinutes * 1 minutes;
        price = etherCostOfEachToken * 1 ether;
        tokenReward = token(addressOfTokenUsedAsReward);
    }
    //폴백함수. 컨트랙트 하나에 딱 하나만 정의 가능
    // 매개변수 선언 x 값 반환 x
    // 2300가스만 사용
    // external payable 필수
    // 스마트컨트랙트가 이더를 받을 수 있게
    // 받고 나서 어떠한 액션을 취하는 것이 가능
    // call 함수로 존재하지 않는 함수가 호출됐을 때 어떠한 액션을 취함

    // 0.6 전후로 사용법이 바뀜(따라서 책의 코드는 옛날 것)
    // receive() external payable { : 순수하게 이더만 받을 때 작동
    // fallback() external payable-선택 { : 기본형태이나 payable 추가하면 이더 받고 나서도 무언가 가능

    // function () external payable { // 따라서 이 부분은
    fallback () external payable{ // 으로 수정
        require(!crowdsaleClosed);
        uint amount = msg.value; // wei단위.
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount / price);
        emit FundTransfer(msg.sender, amount, true);
    }
    
    // 여기도 마찬가지로 now 교체
    modifier afterDeadline() { if(block.timestamp >= deadline) _;}

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