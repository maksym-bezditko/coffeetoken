# CoffeeToken

This project includes two main smart contracts: `CoffeeToken` and `CoffeeTokenSale`. The `CoffeeToken` is an ERC20 token with burnable functionality and role-based access control. The `CoffeeTokenSale` contract handles the sale of `CoffeeToken` tokens, allowing users to purchase tokens with Ether.

## Prerequisites

To work with this project, you need to have the following installed:

- [Node.js](https://nodejs.org/)
- [Truffle](https://www.trufflesuite.com/truffle)
- [Ganache](https://www.trufflesuite.com/ganache) (for local blockchain development)
- [MetaMask](https://metamask.io/) (for interacting with the dApp)

## Installation

1. **Clone the repository:**

   ```
   git clone https://github.com/your-username/coffee-token-project.git
   cd coffee-token-project
   ```

2. **Install dependencies:**

   ```
   npm install
   ```

3. **Compile the contracts:**

   ```
   truffle compile
   ```

4. **Deploy the contracts to a local blockchain (Ganache):**

   ```
   truffle migrate
   ```

## CoffeeToken Contract

`CoffeeToken` is an ERC20 token with additional features:

- **Minting:** Only addresses with the `MINTER_ROLE` can mint new tokens.
- **Burning:** Any token holder can burn their tokens.
- **Role-based Access Control:** Uses OpenZeppelin's `AccessControl` for role management.

### Deployment Parameters

- `defaultAdmin` - The address that will have the default admin role.
- `minter` - The address that will have the minter role.

### Functions

- `mint(address to, uint256 amount)`: Mint new tokens to the specified address. Requires the caller to have the `MINTER_ROLE`.
- `buyOneCoffee()`: Burns 1 token from the caller's balance. Emits the `CoffeePurchased` event.
- `buyOneCoffeeFrom(address account)`: Burns 1 token from the specified account's balance. Requires the caller to have an allowance for the specified account. Emits the `CoffeePurchased` event.

## CoffeeTokenSale Contract

`CoffeeTokenSale` handles the sale of `CoffeeToken` tokens. It allows users to purchase tokens by sending Ether.

### Deployment Parameters

- `_owner` - The owner of the contract who has the `ADMIN_ROLE`.
- `_token` - The address of the deployed `CoffeeToken` contract.
- `_priceInWei` - The price of one token in Wei.

### Functions

- `setPrice(uint256 _priceInWei)`: Sets the price of tokens in Wei. Requires the caller to have the `PRICE_CHANGER_ROLE`.
- `grantPriceChangerRole(address account)`: Grants the `PRICE_CHANGER_ROLE` to the specified address. Requires the caller to have the `ADMIN_ROLE`.
- `revokePriceChangerRole(address account)`: Revokes the `PRICE_CHANGER_ROLE` from the specified address. Requires the caller to have the `ADMIN_ROLE`.
- `purchase()`: Allows users to purchase tokens by sending Ether. If the sent Ether is more than the price, the remainder is refunded.
- `withdraw()`: Allows the owner to withdraw all Ether from the contract. Requires the caller to have the `ADMIN_ROLE`.

## Testing

To run the tests, use the following command:

```
truffle test
```

## Usage

1. **Run a local blockchain:**

   Start Ganache and configure it to match the settings in your `truffle-config.js`.

2. **Deploy the contracts:**

   ```
   truffle migrate
   ```

3. **Interact with the contracts:**

   Use Truffle Console or a front-end application to interact with the deployed contracts. For example:

   ```
   truffle console
   ```

   In the console:

   ```js
   let coffeeToken = await CoffeeToken.deployed();
   let coffeeTokenSale = await CoffeeTokenSale.deployed();

   // Mint tokens
   await coffeeToken.mint("0xYourAddress", 100);

   // Purchase tokens
   await coffeeTokenSale.purchase({ from: "0xYourAddress", value: web3.utils.toWei("1", "ether") });
   ```
