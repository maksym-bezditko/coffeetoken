// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

interface IERC20Token {
    function transfer(address account, uint256 amount) external;

    function decimals() external view returns (uint256);
}

contract CoffeeTokenSale is AccessControl {
    bytes32 public constant PRICE_CHANGER_ROLE =
        keccak256("PRICE_CHANGER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    uint256 priceInWei;
    IERC20Token token;
    address public owner;

    constructor(address _owner, address _token, uint256 _priceInWei) {
        _grantRole(ADMIN_ROLE, _owner);
        _grantRole(PRICE_CHANGER_ROLE, _owner);

        owner = _owner;
        token = IERC20Token(_token);

        setPrice(_priceInWei);
    }

    function setPrice(uint256 _priceInWei) public onlyRole(PRICE_CHANGER_ROLE) {
        require(priceInWei > 0, "Price should be more that 0");
        require(priceInWei != _priceInWei, "Such price is the current price");

        priceInWei = _priceInWei;
    }

    function grantPriceChangerRole(
        address account
    ) public onlyRole(ADMIN_ROLE) {
        require(
            hasRole(PRICE_CHANGER_ROLE, account),
            "The role has already been granted"
        );

        _grantRole(PRICE_CHANGER_ROLE, account);
    }

    function revokePriceChangerRole(
        address account
    ) public onlyRole(ADMIN_ROLE) {
        require(
            hasRole(PRICE_CHANGER_ROLE, account),
            "The role is not granted yet!"
        );

        _revokeRole(PRICE_CHANGER_ROLE, account);
    }

    function purchase() public payable {
        require(msg.value >= priceInWei, "Not enough funds!");

        uint256 tokenToBuy = msg.value / priceInWei;
        uint256 remainder = msg.value % priceInWei;

        uint256 tokenAmount = tokenToBuy * 10 ** token.decimals();

        require(tokenAmount > 0, "Not enough tokens to buy");

        token.transfer(msg.sender, tokenAmount);

        if (remainder > 0) {
            payable(msg.sender).transfer(remainder);
        }
    }

    function withdraw() public onlyRole(ADMIN_ROLE) {
        payable(owner).transfer(address(this).balance);
    }
}
