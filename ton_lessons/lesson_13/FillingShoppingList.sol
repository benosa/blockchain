pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "BaseDebot.sol";
import "IListPurchase.sol";

contract FillingShoppingList is BaseDebot {

    string private title;
    uint private quantity;
    
    //constructor(uint pubKey) public BaseDebot(pubKey){}

    function _getStat(uint32 answerId) internal view override{
        optional(uint256) none;
        IListPurchase(m_address).getStat{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }

    function setStat(Stat stat) public override{
        m_stat = stat;
        _menu();
    }

    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (todo/done/total) tasks",
                    m_stat.incompleteCount,
                    m_stat.completeCount,
                    m_stat.completeCount + m_stat.incompleteCount
            ),
            sep,
            [
                MenuItem("Add purchase item","",tvm.functionId(addPurchase)),
                MenuItem("Show purchases list","",tvm.functionId(getPurchases)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function addPurchase(uint32 index) public {
        index = index;
        Terminal.input(tvm.functionId(setTitle), "Tutle in one line please:", false);
        Terminal.input(tvm.functionId(setQuantity), "Quantity in one line please:", false);
        addPurchase_(title, quantity);
    }

    function setTitle(string title_) public {
        title = title_;
    }

    function setQuantity(uint quantity_) public {
        quantity = quantity_;
    }

    function addPurchase_(string title, uint quantity) public view {
        optional(uint256) pubkey = 0;
        IListPurchase(m_address).addPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(title, quantity);
    }

    function getPurchases(uint32 index) public view {
        index = index;
        optional(uint256) none;
        IListPurchase(m_address).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(getPurchases_),
            onErrorId: 0
        }();
    }

    function getPurchases_( Purchase[] purchases ) public {
        uint32 i;
        if (purchases.length > 0 ) {
            Terminal.print(0, "Your tasks list:");
            for (i = 0; i < purchases.length; i++) {
                Purchase purchase = purchases[i];
                string completed;
                if (purchase.isBought) {
                    completed = '✓';
                } else {
                    completed = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\"  at {} price {}", purchase.id, completed, purchase.title, purchase.created, purchase.price));
            }
        } else {
            Terminal.print(0, "Your tasks list is empty");
        }
        _menu();
    }

    function deletePurchase(uint32 index) public {
        index = index;
        if (m_stat.completeCount + m_stat.incompleteCount > 0) {
            Terminal.input(tvm.functionId(deletePurchase_), "Enter task number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no tasks to delete");
            _menu();
        }
    }

    function deletePurchase_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IListPurchase(m_address).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }
}