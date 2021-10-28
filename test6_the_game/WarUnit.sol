pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'Game.sol';
import 'GameObject.sol';
import 'BaseStation.sol';

/**
* Контракт "Военный юнит" (Родитель "Игровой объект")
*/
contract WarUnit is GameObject {

    string private nameValue;

    BaseStation private baseStation;

    int private newPower = 100;

    /**
    * конструктор принимает "Базовая станция" и
    * вызывает метод "Базовой Станции" "Добавить военный юнит" 
    * а у себя сохраняет адрес "Базовой станции"
    */
    constructor(BaseStation station, string name) public {
		//require(tvm.pubkey() != 0, 101);
		//require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        baseStation = station;
        nameValue = name;
        station.addWarUnit(nameValue, this);
	}

    /**
    * атаковать (принимает ИИО [его адрес])
    */
    function attack(GameObject addr) public {
        //require(tvm.pubkey() != 0, 101);
		//require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        addr.takeAttack(getPowerAttack(), nameValue);
    }

    /**
    * получить силу защиты
    */
    function getPowerProtection() internal virtual override returns(int){
        return super.getPowerProtection() + newPower;
    }

    /**
    * получить силу атаки
    */
    function getPowerAttack() public virtual returns(int){
        return random() + 1;
    }

    /**
    * обработка гибели [вызов метода самоуничтожения + убрать военный юнит из базовой станции]
    */
    function handleDeath(address dest) external testDeathBaseStation(dest) override {
        baseStation.deleteWarUnit(BaseStation(dest));
        selfDestruction(BaseStation(dest));
    }

    /**
    * смерть из-за базы (проверяет, что вызов от родной базовой станции только будет работать) [вызов метода самоуничтожения]
    */
    modifier testDeathBaseStation(address dest) {
        require(BaseStation(dest) ==  baseStation, 1005, "Error: Event delete call from not own base station");
        _;
    }

    /**
    * Test function - Remove it!
    */
    function getBaseStation() view public returns(address)  {
        return baseStation;
    }

    /**
    * Test function - Remove it!
    */
    function getName() view public returns(string)  {
        return nameValue;
    }
}