pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'Game.sol';

/**
* Контракт "Игровой объект" (Реализует "Интерфейс Игровой объект")
*/
contract GameObject is Game {
    //свойство с начальным количеством жизней (например, 5)
    int private life = 5;
    int private protection = 100;
    uint private randNonce = 0;

    struct AttackerLog{
        address addr;
        string name;
        int power;
    }

    mapping(uint => AttackerLog) public arrayAttacks;

    function random() internal returns (int) {   
        rnd.shuffle();
        return rnd.next(life);
    }

    /**
    * получить силу защиты
    */
    function getPowerProtection() internal virtual returns(int){
        //return life * protection * 100;
        return protection;
    }

    /**
    * принять атаку [адрес того, кто атаковал можно получить из msg] external
    */
    function takeAttack(int powerAttack, string name) external override {
        tvm.accept();
        require(!testDeath(), 1001, 'Object is dead');
        if( (getPowerProtection() - powerAttack) <= 0){
            int res = life - random();
            if(res <= 0){
                life = 0;
                this.handleDeath(msg.sender);
            }else life = life - res;
        }
        arrayAttacks[now] = AttackerLog(msg.sender, name, powerAttack);
    }

    /**
    * проверить, убит ли объект (private)
    */
    function testDeath() private returns(bool) {
        if(life == 0)return true;
        return false;
    }

    /**
    * обработка гибели [вызов метода самоуничтожения (сл в списке)]
    */
    function handleDeath(address dest) external virtual {
        selfDestruction(dest);
    }

    /**
    * отправка всех денег по адресу и уничтожение
    */
    function selfDestruction(address dest) internal {
        dest.transfer(1, true, 128 + 32);
    }

    function getLife() public returns(int){
        return life;
    }

    function setLife(int value) public {
        life = life + value;
    }

     function getProtection() public returns(int){
        return protection;
    }

    function setProtection(int value) public {
        protection = protection + value;
    }

    /**
    * Test function - Remove it!
    */
    function getLogs() public returns(AttackerLog[]) { 
        tvm.accept();
        mapping(address=> string) lmap;
        AttackerLog[] logArr;
        for((uint key, AttackerLog value) : arrayAttacks){
            logArr.push(value);
        }
        return logArr;
    }
}
