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
        if(balanceOf[msg.sender] < _value) return; 
        if(balanceOf[_to] + _value < balanceOf[_to]) return; // 두 가지를 다 체크 후 실행
        balanceOf[msg.sender] -= _value; 
        balanceOf[_to] += _value; 
        emit Transfer(msg.sender, _to, _value);
    }
}

contract CrowdFundwWithUnsecureToken {
    UnsecureGeneralWalletCompatibleToken3 tokenReward;
    uint transferCount;

    function transfer() external {
        transferCount ++;
        tokenReward.transfer(msg.sender, 10);
    }
}