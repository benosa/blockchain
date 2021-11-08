
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract MyMap {
   
    uint8 public sequence = 0;

    struct Task {
        string taskName;
        uint32 timestamp;
        bool closed;  
    }

    mapping (uint8 => Task) public tasks; 

    uint8[] public storeNumbers;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function addTask(string taskName)  public  {
        tvm.accept();       
        Task task = Task(taskName, now, false);
        tasks[sequence] = task;
        sequence++;
        return;
    }

    function iterate() public returns(Task[]) {
        tvm.accept(); 
        Task[] tasksOut;
        for((uint8 key, Task value) : tasks){
            tasksOut.push(value);
        }
        return tasksOut;
    }
}
