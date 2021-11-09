pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;

import "Purchase.sol";
import "Stat.sol";
import "AListPurchase.sol";
contract ListPurchase is AListPurchase {

    uint32 m_count;

    mapping(uint32 => Purchase) m_purchases;

    constructor(uint pubKey) public AListPurchase(pubKey){}

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    function addPurchase(string title, uint quantity) public onlyOwner override{
        tvm.accept();
        m_count++;
        m_purchases[m_count] = Purchase(m_count, title, quantity, now, false, 0);
    }

    function deletePurchase(uint32 id) public onlyOwner override{
        require(m_purchases.exists(id), 102);
        tvm.accept();
        delete m_purchases[id];
    }

    function buy(uint32 id, uint price) public onlyOwner override{
        optional(Purchase) purchase = m_purchases.fetch(id);
        require(purchase.hasValue(), 102);
        tvm.accept();
        Purchase thisPurchase = purchase.get();
        thisPurchase.isBought = true;
        thisPurchase.price = price;
        m_purchases[id] = thisPurchase;
    }

    function getPurchases() public view override returns (Purchase[] purchase) {
        for((uint32 id, Purchase item) : m_purchases) {
            purchase.push(Purchase(id, item.title, item.quantity, item.created, item.isBought, item.price));
        }
    }
    
    function getStat() public view override returns (Stat stat) {
        uint32 completeCount;
        uint32 incompleteCount;

        for((, Purchase purchase) : m_purchases) {
            if  (purchase.isBought) {
                completeCount ++;
            } else {
                incompleteCount ++;
            }
        }
        stat = Stat( completeCount, incompleteCount );
    }

}