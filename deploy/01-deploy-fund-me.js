//import
//main function
//calling of main function

// function deployFunc(hre){
//     console.log("hi")
// }
// module.exports.default = deployFunc

//importing networkConfig
const { networkConfig, developmentChains } = require("../helper-hardhat-config") // this syntax is used just to extrpolate just the network from the helper-hardhat-config file
const { network } = require("hardhat")
const { verify } = require("../utils/verify")
// the line below assigns an asynchronious function that takes in two hre values to module.exports
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    // we are going to use our chainId

    // const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    let ethUsdPriceFeedAddress
    if (developmentChains.includes(network.name)) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    // mocking means: if the contract doesn't exist, we deploy a minimal version of it for our local testing
    //creat a new file in the deploy folder called 00-deploy-mocks.js
    const args = [ethUsdPriceFeedAddress]
    // in order to use the deploy function, we do...
    const fundme = await deploy("FundMe", {
        from: deployer,
        args: args, // put price feed address here
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        //verify
        await verify(fundme.address, args)
    }
    log("------------------------------------------")
}
module.exports.tags = ["all", "fundme"]
