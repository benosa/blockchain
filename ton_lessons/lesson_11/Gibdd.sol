pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Gibdd {

    uint public tvmPubkey;

    uint public msgPubkey;

    address public msgAddress;

    address public incomeAddress;

    constructor() public{
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function registCar(address carAddress) public {
        tvm.accept();
        tvmPubkey = tvm.pubkey();
        msgPubkey = msg.pubkey();

        msgAddress = msg.sender;
        incomeAddress = carAddress;
    }
}