pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract StoreQueue {

    string[] public storeQueue;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
    }

    modifier checkEmpty() {
        require(!storeQueue.empty(), 103);
        _;
    }

    function pushToQueue (string value) public {
        tvm.accept();
        storeQueue.push(value);
    }

    function getFromQueue () public checkEmpty() returns (string){
        tvm.accept();
        string res = storeQueue[0];
        for (uint i = 0; i < storeQueue.length-1; i++){
            storeQueue[i] = storeQueue[i+1];
        }
        storeQueue.pop();
        return res;
    }

    function renderHelloWorld () public pure returns (string) {
        return 'helloWorld';
    }
}
