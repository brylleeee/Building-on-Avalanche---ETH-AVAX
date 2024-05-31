// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenGaming is ERC20, Ownable {
    event RedeemedRewards(address redeemer, uint256 itemId, uint256 quantity);

    struct Rewards {
        uint256 id;
        string name;
        uint256 DGNprice;
        uint256 quantity;
    }

    Rewards[] public rewards;

    mapping(address => uint256[]) public userInventory;

    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {

        rewards.push(Rewards(0, "Diamond Sword", 30, 54));
        rewards.push(Rewards(1, "Lucifer's Wings", 80, 23));
        rewards.push(Rewards(2, "Achille's Boots", 25, 89));
        rewards.push(Rewards(3, "Michael Angelo's Chisel", 15, 43));
        rewards.push(Rewards(4, "Ultra Boost", 70, 38));
    }

    function AddDGN(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function TransferDGN(address recipient, uint256 amount) public {
        require(recipient != address(0), "Invalid player address");
        require(amount > 0, "You must transfer DGN amount greater than zero");

        transfer(recipient, amount);
    }

    function RedeemRewards(uint256 itemId, uint256 quantity) public {
    Rewards storage item = rewards[itemId];
    require(itemId > 0, "Invalid reward item ID");
    require(quantity > 0, "Quantity of redemption must be greater than zero");
    require(balanceOf(msg.sender) >= item.DGNprice * quantity, "Insufficient DGN balance");

    _burn(msg.sender, item.DGNprice * quantity);

    userInventory[msg.sender].push(itemId);
    item.quantity -= quantity;

    emit RedeemedRewards(msg.sender, itemId, quantity);
    }

    function RedeemedRewardsChecker(address user, uint256 itemId) public view returns (bool) {
    for (uint256 i = 0; i < userInventory[user].length; i++) {
        if (userInventory[user][i] == itemId) {
            return true;
        }
    }
    return false;
    }

    function RedeemedRewardsQuantityChecker(address user, uint256 itemId) public view returns (uint256) {
        uint256 quantity = 0;
            for (uint256 i = 0; i < userInventory[user].length; i++) {
        if (userInventory[user][i] == itemId) {
            quantity++;
        }
    }
    return quantity;
    }


    function CheckDGNBalance(address user) public view returns (uint256) {
        return balanceOf(user);
    }

    function BurnDGN(uint256 amount) public {
        require(balanceOf(_msgSender()) >= amount, "Please burn DGN lower or equal to your current amount.");
        _burn(msg.sender, amount);
    }
}
