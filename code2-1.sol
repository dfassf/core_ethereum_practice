// pragma solidity >0.4.15 <=0.8.12;

pragma solidity ^0.4.15;

contract MyToken {
    mapping(address => uint256) public balanceOf;

    function MyToken(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

    function getBalance(address _account) public constant returns (uint256) {
        return balanceOf[_account];
    }
}
