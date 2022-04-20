contract ERC20 {
    // 오류가 남
    // 현재까지 공급된 총 토큰 수
    function totalSupply() constant returns (uint totalSupply);
    // 어카운트의 잔고
    function balanceOf(address _owner) constant returns (uint balance); 
    // 송금
    function transfer(address _to, uint _value) returns (bool success); 
    // 사람끼리 송금
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
    // 이건 뭔지 모르겠음.
    function approve(address _spender, uint _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}