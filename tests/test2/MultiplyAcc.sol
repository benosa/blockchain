pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract MultiplyAcc {

	uint public accumulator  = 1;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

    modifier checkRange(uint value) {
        require((value >= 1) && (value <= 10), 103);
        _;
    }

	function mul(uint value) public checkRange(value) returns (string) {
        tvm.accept();
		accumulator *= value;
        return format("{}", accumulator);
	}

    function renderAccumulator () public view returns (string) {
        tvm.accept();
        return format("{}", accumulator);
    }
}