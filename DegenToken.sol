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

    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {

        rewards.push(Rewards(1, "Diamond Sword", 30, 54));
        rewards.push(Rewards(2, "Lucifer's Wings", 80, 23));
        rewards.push(Rewards(3, "Achille's Boots", 25, 89));
        rewards.push(Rewards(4, "Michael Angelo's Chisel", 15, 43));
        rewards.push(Rewards(5, "Ultra Boost", 70, 38));
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
        require(quantity >= quantity, "Quantity of redemption must be greater than zero");
        item.quantity -= quantity;

        emit RedeemedRewards(msg.sender, itemId, quantity);
    }

    function CheckDGNBalance(address user) public view returns (uint256) {
        return balanceOf(user);
    }

    function BurnDGN(uint256 amount) public {
        require(balanceOf(_msgSender()) >= amount, "Please burn DGN lower or equal to your current amount.");
        _burn(msg.sender, amount);
    }
}
