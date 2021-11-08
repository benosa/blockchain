pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/*
Exception codes:
100 - message sender is not a wallet owner.
101 - contract's public key is not set.
102 - message not has signature (msg.pubkey() is not zero) or message is not signed with the owner's private key
103 - Created token name not have unique name
*/
contract TicketToken {

    struct Ticket {  
        string description;
        uint price;
        uint owner;
    }

    mapping(bytes => Ticket) ticketsMap;

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);

		tvm.accept();
		_;
	}

    modifier checkUniqueName(bytes name) {
        require(!ticketsMap.exists(name), 103);
        tvm.accept();
        _;
    }

    modifier checkExistTicket(bytes name) {  
        require(ticketsMap.exists(name), 104);
        _;
    }

    /// @dev Contract constructor.
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function createToken(string name, string description, uint price) public checkOwnerAndAccept checkUniqueName(name){       
        ticketsMap[name] = Ticket(description, price, msg.pubkey());
    }

    function getTokenOwner(string name) public view checkExistTicket(name) returns (uint){
        return ticketsMap[name].owner;
    }

    function getTokenInfo(string name) public view checkExistTicket(name) returns (string ticketName, string ticketDescription, uint ticketPrice){
        ticketName = name;
        ticketDescription = ticketsMap[name].description;
        ticketPrice = ticketsMap[name].price;
    }

    function changeOwner(string name, uint pubKeyOfNewOwner) public checkExistTicket(name) {
        require(msg.pubkey() == ticketsMap[name].owner, 101);
        tvm.accept();
        ticketsMap[name].owner = pubKeyOfNewOwner;
    }

    function changePrice(string name, uint256 price) public checkExistTicket(name){
        require(msg.pubkey() == ticketsMap[name].owner, 101);
        tvm.accept();
        ticketsMap[name].price = price;
    }

}
