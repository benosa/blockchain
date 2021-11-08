pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'BaseContract.sol';

contract ChildContract is BaseContract {
   
    function myPublicFunction(uint value) public override {
       tvm.accept();
       //myParam = value + 1;
       setParam(value + 1);
       callerAddress = msg.sender;
    }

    function myExternalFunction(uint value) virtual external override {
       tvm.accept();
       myParam = value + 1;
       callerAddress = msg.sender;
    }

    function myInternalFunction(uint value) internal override {
       tvm.accept();
       myParam = value + 1;
       callerAddress = msg.sender;
    }

}
