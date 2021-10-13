pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract MultiplyAcc {

	uint public accumulator  = 1;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
	}

    modifier checkRange(uint value) {
        require(value >= 1, 103);
        require( value <= 10, 104);
        _;
    }

	function mul(uint value) public checkRange(value) returns (uint) {
        tvm.accept();
		accumulator *= value;
        return accumulator;
	}

    function renderAccumulator () public view returns (string) {
        tvm.accept();
        return format("{}", accumulator);
    }
}