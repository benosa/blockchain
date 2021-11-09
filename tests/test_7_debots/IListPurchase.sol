pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;

import "Purchase.sol";
import "Stat.sol";

interface IListPurchase {
    function addPurchase(string title, uint quantity) external;
    function deletePurchase(uint32 id) external;
    function buy(uint32 id, uint price)external;
    function getPurchases() external view returns (Purchase[] purchases);
    function getStat() external view returns (Stat stat);
}