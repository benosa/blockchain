pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {

    uint8 public sequence = 0;

    struct Task {
        bytes taskName;
        uint32 timestamp;
        bool closed;  
    }

    mapping (uint8 => Task) public tasks; 

    modifier checkId(uint8 id) {
        require(!(id >= sequence), 103);
        require(!(tasks[id].timestamp == 0), 104);
        _;
    }

    constructor() public {      
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
    }

    function addTask(bytes taskName)  public  {
        tvm.accept();       
        Task task = Task(taskName, now, false);
        tasks[sequence] = task;
        tasks[sequence+1] = task;
        sequence++;
    }

    function getOpenedTasks()  public  view returns (uint8){
        tvm.accept();
        uint8 totalValue = 0;

        Task[] tasksOut;
        for((uint8 key, Task value) : tasks){
             if(!value.closed)
             totalValue++;
        }
        return totalValue;
    }

    function getAllTasks()  public  returns (mapping (uint8 => Task)){
        tvm.accept();

        return tasks;
    }

    function getTaskNameById(uint8 id)  public checkId(id)  returns (bytes){
        tvm.accept();
        return tasks[id].taskName;
    }

    function deleteTaskById(uint8 id)  public checkId(id) {
        tvm.accept();
        delete tasks[id];
    }

    function closeTaskById(uint8 id)  public checkId(id) {
        tvm.accept();
        tasks[id].closed = true;
    }

}
