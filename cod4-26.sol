pragma solidity >0.4.16;

contract SecureGeneralWalletCompatibleToken {

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
    
    // revert 적용: 전체 실패로 하고 트랜잭션 실행 이전 상태로 되돌림
    function transfer(address _to, uint256 _value) public {
        if(balanceOf[msg.sender] < _value) revert();
        if(balanceOf[_to] + _value < balanceOf[_to]) revert();
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }    
    // throw와의 차이점은 가스 환불 값. throw는 초기 세팅값대로 환불 그러나 revert는  revert 실행 시점까지만.
    
}