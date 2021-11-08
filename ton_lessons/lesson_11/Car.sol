pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "Registable.sol";

contract Car {

    uint public doors;

    uint static public carNumber;

    uint public tvmPubkey;
    uint public msgPubkey;

    address public msgAddress;

    constructor(uint _doors) public{
        tvm.accept();
        doors = _doors;
    }

    function sendCarToGibdd(Registable gibddAddress) public {
        tvm.accept();
        gibddAddress.registCar(this);
    }

     function checkKeysAndAddress(address carAddress) public {
        tvm.accept();
        tvmPubkey = tvm.pubkey();
        msgPubkey = msg.pubkey();

        msgAddress = msg.sender;
    }
}