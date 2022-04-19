pragma solidity >0.4.16;

contract UnsecureGeneralWalletCompatibleToken3 {

    string public name;
    string public symbol;
    uint8 public decimals;

    mapping (address => uint256) public balanceOf;

    event Transfer(address _from, address _to, uint _value);

    constructor (string memory tokenName, string memory tokenSymbol, uint8 decimalUnits, uint256 initialSupply) {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address _to, uint256 _value) public {
        if(balanceOf[msg.sender] < _value) return; // 호출자 잔고가 거래량보다 적으면 취소
        balanceOf[msg.sender] -= _value; // 그렇지 않으면 실행
        if(balanceOf[_to] + _value < balanceOf[_to]) return; // 수금인의 잔고+ 거래량이 수금인의 잔고보다 작으면 취소(???)
        // -> 이 부분은 오버플로우 방지용인데, 오버플로우-100이 잔고인 상태에서 500을 보내면 오버플로우가 발생, 돈이 공중분해됨.
        balanceOf[_to] += _value; // 수금인의 잔고 플러스
        emit Transfer(msg.sender, _to, _value);
    }
}