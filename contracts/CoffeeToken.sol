// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CoffeeToken is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event CoffeePurchased(
        address indexed receiver,
        address indexed buyer,
        uint256 indexed amount
    );

    constructor(
        address defaultAdmin,
        address minter
    ) ERC20("CoffeeToken", "CFE") {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(MINTER_ROLE, minter);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount * 10 ** decimals());
    }

    function buyOneCoffee() public {
        require(
            balanceOf(_msgSender()) >= 1 * 10 ** decimals(),
            "Insufficient funds!"
        );

        _burn(_msgSender(), 1 * 10 ** decimals());

        emit CoffeePurchased(_msgSender(), _msgSender(), 1);
    }

    function buyOneCoffeeFrom(address account) public {
        uint256 amount = 1 * 10 ** decimals();

        require(
            balanceOf(account) >= amount,
            "Insufficient balance to buy coffee!"
        );

        require(
            allowance(account, _msgSender()) >= amount,
            "Allowance too low to buy coffee!"
        );

        _spendAllowance(account, _msgSender(), 1 * 10 ** decimals());
        _burn(account, 1 * 10 ** decimals());

        emit CoffeePurchased(_msgSender(), account, 1);
    }
}
