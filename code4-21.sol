pragma solidity >0.4.16;

contract WalletCompatibleToken {
    string public constant name = "Wallet Compatible Token";
    string public constant symbol = "WCTKs";
    uint8 public constant decimals = 18;

    mapping (address => uint256) public balanceOf;

    event Transfer(address _from, address _to, uint _value);

    constructor(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address _to, uint256 _value) public {
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }
}