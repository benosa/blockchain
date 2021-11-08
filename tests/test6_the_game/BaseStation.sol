pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';

/**
* Контракт "Базовая станция" (Родитель "Игровой объект")
*/
contract BaseStation is GameObject {

    int private newPower = 1000;

    mapping(GameObject => string) private warUnits;

    /**
    * получить силу защиты
    */
    function getPowerProtection() internal override returns(int){
        int power = super.getPowerProtection() + newPower;
    }

    /**
    * Добавить военный юнит (добавляет адрес военного юнита в массив или другую структуру данных)
    */
    function addWarUnit(string name, GameObject addr) external {
        warUnits[addr] = name;
    }

    /**
    * Убрать военный юнит
    */
    function deleteWarUnit(GameObject addr) external {
        tvm.accept(); 
        delete warUnits[addr];
    }

    /**
    * обработка гибели [вызов метода самоуничтожения + вызов метода смерти для каждого из военных юнитов базы]
    */
    function handleDeath(address dest) external override {
        for((GameObject key, string value) : warUnits){
           key.handleDeath(dest);
        }
        dest.transfer(1, true, 128 + 32);
    }

    /**
    * Test function - Remove it!
    */
    function getUnits() public returns(mapping(address=> string)) { 
        mapping(address=> string) lmap;
        for((GameObject key, string value) : warUnits){
            lmap[key] = value;
        }
        return lmap;
    }

    
    /*function setUnitName(address addr, string name) external {
        if(warUnits.exists(GameObject(addr))) warUnits[GameObject(addr)] = name;
    }*/
}