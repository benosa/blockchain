pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {

    uint8 public sequence = 0;

    struct Task {
        string taskName;
        uint32 timestamp;
        bool closed;  
    }

    mapping (uint8 => Task) public tasks; 

    uint8[] public storeNumbers;

    modifier checkId(uint8 id) {
        require(!(id >= sequence), 103);
        require(!(tasks[id].timestamp == 0), 104);
        _;
    }

    constructor() public {      
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
    }

    function addTask(string taskName)  public  {
        tvm.accept();       
        Task task = Task(taskName, now, false);
        storeNumbers.push(sequence);
        tasks[sequence] = task;
        sequence++;
    }

    function getOpenedTasks()  public  view returns (uint8){
        tvm.accept();
        uint8 totalValue = 0;
        /*for (uint8 i = 0; i < sequence - 1; i++) {
            if(!tasks[i].closed)
             totalValue++;
        }*/
        for (uint8 i = 0; i < storeNumbers.length; i++){
             if(!tasks[storeNumbers[i]].closed)
             totalValue++;
        }
        return totalValue;
    }

    function getAllTasks()  public  returns (mapping (uint8 => Task)){
        tvm.accept();
        /*Task[] ret;
        for (uint8 i = 0; i < sequence - 1; i++) {
            ret.push(tasks[i]);
        }*/
        return tasks;
    }

    function getTaskNameById(uint8 id)  public checkId(id)  returns (string){
        tvm.accept();
        return tasks[id].taskName;
    }

    function deleteTaskById(uint8 id)  public checkId(id) {
        tvm.accept();

        uint8 index = 0;

        for (uint8 i = 0; i < storeNumbers.length; i++){
            if(storeNumbers[i] == id)index = i;
        }

        //require(index > 0, 204, "Cant remove element");

        for (index; index < storeNumbers.length-1; index++){
            storeNumbers[index] = storeNumbers[index+1];
        }
        storeNumbers.pop();
        delete tasks[id];
    }

    function closeTaskById(uint8 id)  public checkId(id) {
        tvm.accept();
        tasks[id].closed = true;
    }

}
