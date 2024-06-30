// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GameClone {
    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals = 10;
    uint256 public totalSupply = 0;

    mapping(uint256 => string) public ItemName;
    mapping(uint256 => uint256) public Itemprice;
    mapping(address => uint256) public balance;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;

    constructor() {
        name = "Polygon";
        symbol = "Matic";
        owner = msg.sender;

        GameStore(0, "sticker", 500);
        GameStore(1, "phone", 1000);
        GameStore(2, "laptop", 20000);
        GameStore(3, "servers", 25000);
    }

    event Mint(address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Redeem(address indexed user, string itemName);

    function GameStore(uint256 itemId, string memory _itemName, uint256 _itemPrice) public {
        require(owner == msg.sender, "This Function can only be used by the owner");
        ItemName[itemId] = _itemName;
        Itemprice[itemId] = _itemPrice;
    }

    function mint() payable external {
        require(owner == msg.sender, "This Function can only be used by the owner");
        totalSupply += msg.value;
        balance[msg.sender] += msg.value;
        emit Mint(msg.sender, msg.value);
        emit Transfer(address(0), msg.sender, msg.value);
    }

    function balanceOf(address accountAddress) external view returns (uint256) {
        return balance[accountAddress];
    }

    function transfer(address receiver, uint256 amount) external returns (bool) {
        require(balance[msg.sender] >= amount, "Insufficient Token.");
        balance[msg.sender] -= amount;
        balance[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function burn(uint256 amount) external {
        require(amount <= balance[msg.sender], "Insufficient Token.");
        balance[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function Itemredeem(uint256 accId) external returns (string memory) {
        uint256 redemptionAmount = Itemprice[accId];
        require(balance[msg.sender] >= redemptionAmount, "Insufficient Token to redeem the item.");

        balance[msg.sender] -= redemptionAmount;
        redeemedItems[msg.sender][accId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, ItemName[accId]);

        return ItemName[accId];
    }

    function getRedeemedItemCount(address user) external view returns (uint256) {
        return redeemedItemCount[user];
    }
}
