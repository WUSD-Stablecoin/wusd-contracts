var ExampleDaiCoin = artifacts.require("./ExampleDaiCoin.sol");
var ExampleUsdcCoin = artifacts.require("./ExampleUsdcCoin.sol");
var ExampleTusdCoin = artifacts.require("./ExampleTusdCoin.sol");
var ExamplePaxCoin = artifacts.require("./ExamplePaxCoin.sol");
var WUSD = artifacts.require("./WUSD.sol");

module.exports = function(deployer) {
  deployer.then(async () => {
    await deployer.deploy(ExampleDaiCoin);
    var dai = await ExampleDaiCoin.deployed();
    await deployer.deploy(ExampleUsdcCoin);
    var usdc = await ExampleUsdcCoin.deployed();
    await deployer.deploy(ExampleTusdCoin);
    var tusd = await ExampleTusdCoin.deployed();
    await deployer.deploy(ExamplePaxCoin);
    var pax = await ExamplePaxCoin.deployed();
    await deployer.deploy(WUSD, dai.address, usdc.address, tusd.address, pax.address,  dai.address, usdc.address, tusd.address, pax.address)
  })
};
