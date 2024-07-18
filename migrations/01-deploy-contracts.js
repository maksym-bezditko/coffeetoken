const CoffeeToken = artifacts.require("CoffeeToken");
const CoffeeTokenSale = artifacts.require("CoffeeTokenSale");

module.exports = async function (deployer, _, accounts) {
	const defaultAdmin = accounts[0];
	const minter = accounts[1];
	const priceInWei = web3.utils.toWei("0.01", "ether");

	await deployer.deploy(CoffeeToken, defaultAdmin, minter);
	const coffeeTokenInstance = await CoffeeToken.deployed();

	await deployer.deploy(CoffeeTokenSale, defaultAdmin, coffeeTokenInstance.address, priceInWei);
	const coffeeTokenSaleInstance = await CoffeeTokenSale.deployed();

	console.log("CoffeeToken deployed at:", coffeeTokenInstance.address);
	console.log("CoffeeTokenSale deployed at:", coffeeTokenSaleInstance.address);
};