pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'MyInterface.sol';

contract BaseContract is MyInterface{

    uint public myParam;
    address public callerAddress;

    function myPublicFunction(uint value) virtual public override {
        tvm.accept();
        myParam = value;
        //save address of callee
        callerAddress = msg.sender;
    }

    function setParam(uint value) public {
        tvm.accept();
        require(value > 7);
        myParam = value * value;
    }

    function myExternalFunction(uint value) virtual external override{
        tvm.accept();
        myParam = value;
        //save address of callee
        callerAddress = msg.sender;
    }

    function myInternalFunction(uint value) virtual internal {
        tvm.accept();
        myParam = value;
        //save address of callee
        callerAddress = msg.sender;
    }

    function myPrivateFunction(uint value) private {
        tvm.accept();
        myParam = value;
        //save address of callee
        callerAddress = msg.sender;
    }

    function myFunctionForTest(uint value) public {
        tvm.accept();
        myPublicFunction(value);
        myInternalFunction(value);
        //myExternalFunction(value);
        this.myExternalFunction(value);
        myPrivateFunction(value);
    }

    function myGetParam() public view returns (uint){
        tvm.accept();
        return myParam;
    }

    function myGetAddress() public view returns (address){
        tvm.accept();
        return callerAddress;
    }

    function checkPrivate(uint value) public {
        tvm.accept();
        myPrivateFunction(value);
    }

    function checkExternal(uint value) public {
        tvm.accept();
        this.myExternalFunction(value);
    }

    function checkPublic(uint value) public {
        tvm.accept();
        myPublicFunction(value);
    }
    

}
