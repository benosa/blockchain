pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "Registable.sol";
contract Bank is Registable{

    uint public timestamp;

    uint public tvmPubkey;
    uint public msgPubkey;

    address public msgAddress;
    address public incomeAddress;

    constructor() public{
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        timestamp = now;
    }

    function sendValue(address dest, uint128 amount, bool bounce) public view{
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        dest.transfer(amount, bounce, 0);
    }

    function registCar(address carAddress) public override {
        tvm.accept();
        tvmPubkey = tvm.pubkey();
        msgPubkey = msg.pubkey();

        msgAddress = msg.sender;
        incomeAddress = carAddress;
    }

    function anotherRegist(address carAddress) public {
        tvm.accept();
        tvmPubkey = tvm.pubkey();
        msgPubkey = msg.pubkey();

        msgAddress = msg.sender;
        incomeAddress = carAddress;
    }
}