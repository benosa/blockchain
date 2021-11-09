pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;

struct Purchase {
    uint32 id;
    string title;
    uint quantity;
    uint32 created;
    bool isBought;
    uint price;
}