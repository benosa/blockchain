pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;

import "IListPurchase.sol";
abstract contract AListPurchase is IListPurchase {

    uint m_ownerPubkey;

    constructor(uint pubKey) public{
        tvm.accept();
        m_ownerPubkey = pubKey;
    }
}