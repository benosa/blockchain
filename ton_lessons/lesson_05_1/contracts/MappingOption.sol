pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract MappingOption {

    uint32 public timestamp;

    mapping(uint => uint) myMap;

    constructor() public {

        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();

        timestamp = now;
        myMap[4] = 6;
        myMap[19] = 3;
        myMap[1] = 17;
        myMap[5] = 9;
        myMap[33] = 2;
    }

    function renderHelloWorld () public pure returns (string) {
        return 'helloWorld';
    }

    function getList() public returns (uint[]){
        tvm.accept();
        optional(uint, uint) currentOpt = myMap.min();
        uint[] resArr;

        while(currentOpt.hasValue()){
            (uint key, uint val) = currentOpt.get();
            resArr.push(val);
            currentOpt = myMap.next(key);
        }

        return resArr;
    }

     function getList1() public returns (uint[]){
        tvm.accept();
        optional(uint, uint) currentOpt = myMap.min();
        uint[] resArr;

        while(currentOpt.hasValue()){
            (uint key, uint val) = currentOpt.get();
            resArr.push(val);
            currentOpt = myMap.next(key);
        }

        return resArr;
    }

     function getList2() public returns (uint[]){
        tvm.accept();
        optional(uint, uint) currentOpt = myMap.min();
        uint[] resArr;

       for((uint key, uint value) : myMap){
            resArr.push(value);
        }
        return resArr;
    }
}
