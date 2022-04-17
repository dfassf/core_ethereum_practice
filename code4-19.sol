pragma solidity >0.4.16;

contract MinimumViableToken {
    mapping (address => uint256) public balanceOf;
    
    //원래는 function MinimumViableToken(uint256 initialSupply) public ... 임
    constructor (uint256 initialSupply) {
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address _to, uint256 _value) public {
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
    
}