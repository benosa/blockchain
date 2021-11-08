pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract SelfDeployContract{

    uint static public m_value;

    address static public m_parent;

    uint public m_depth;

    mapping(address => bool) m_chilred;

    constructor(uint _depth) public {
        require(
            (tvm.pubkey() != 0 && tvm.pubkey() == msg.pubkey()) ||
            (msg.sender == m_parent)
        );
        tvm.accept();
        m_depth = _depth;
    }

    modifier onlyOwner() {
        require(tvm.pubkey() != 0 && tvm.pubkey() == msg.pubkey());
        tvm.accept();
        _;
    }

    function chamgeMValue(uint _value) onlyOwner public{
        m_value = _value;
    }

    function deploy(uint _value) onlyOwner public returns (address addr){
        TvmCell code = tvm.code();
        addr = new SelfDeployContract{
            value: 2 Ton,
            code: code,
            pubkey: tvm.pubkey(),
            varInit: {
                m_value: _value,
                m_parent: address(this)
            }
        }(m_depth + 1);
        m_chilred[addr] = true;
    }

    function getDeployAddress(uint _value) public view returns (address){
        TvmCell code = tvm.code();
        TvmCell stateInit = tvm.buildStateInit({
            contr: SelfDeployContract,
            code: code,
            pubkey: tvm.pubkey(),
            varInit: {
                m_value: _value,
                m_parent: address(this)
            }
        });
        return address(tvm.hash(stateInit));
    }

    function sendTonsForDeployAddress(uint _value, uint128 amount) onlyOwner public view{
        tvm.accept();
        getDeployAddress(_value).transfer(amount, false);
    }
}