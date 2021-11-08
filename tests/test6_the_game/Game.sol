pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/**
* Интерфейс "Интерфейс Игровой объект" (ИИО).
*/
interface Game{
    /**
    * принять атаку
    */
    function takeAttack(int powerAttack, string name) external;
}
