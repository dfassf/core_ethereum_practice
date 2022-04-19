pragma solidity >0.4.16;

contract SecureGeneralWalletCompatibleToken2 {

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
    
    // require를 쓰면 보다 간결해짐.
    // assert는 함수 내부 오류 검사용. 실패하는 assert문이 있을 때는 컨트랙트에 버그가 있다고 보면 됨.
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] < _value);
        require(balanceOf[_to] + _value < balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }    
}