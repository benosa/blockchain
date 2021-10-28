pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'WarUnit.sol';

/**
* Контракт "Воин" (родитель "Военный юнит")
*/
contract Warrior is WarUnit {

    int private formula = 1;

    constructor(BaseStation station, string nameValue) public WarUnit(station, nameValue){

    }

    /**
    * получить силу защиты
    */
    function getPowerProtection() internal override returns(int){
        int power = super.getPowerProtection() * formula;
    }

    /**
    * получить силу атаки
    */
    function getPowerAttack() public override returns(int){
        return  super.getPowerAttack() + random() * formula;
    }
}