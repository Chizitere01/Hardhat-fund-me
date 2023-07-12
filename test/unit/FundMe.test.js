const { assert } = require("chai")
const { ethers, deployments, getNamedAccounts } = require("hardhat")

describe("FundMe", async function () {
    let fundMe
    let deployer
    let mockV3Aggregator
    beforeEach(async function () {
        //deploy our fundMe contract
        // using HArdhat-deploy
        // to get different accounts...
        // const accounts = await ethers.getSigners() // getsigners is going to return whatever is in the saccount section of your network(in the hardhat-config.js)
        // const accountZero = accounts[0]
        deployer = (await getNamedAccounts()).deployer // extract just the deployer from the getnamed account function.
        await deployments.fixture(["all"])

        fundMe = await ethers.getContractAt("FundMe", deployer) // connect the deployer

        mockV3Aggregator = await ethers.getContractAt(
            "MockV3Aggregator",
            deployer,
        )
        // my name is chizitere
    })
    describe("constructor", async function () {
        it("sets the aggregator addresses correctly", async function () {
            const response = await fundMe.priceFeed()
            assert.equal(response, mockV3Aggregator.address)
        })
    })
})
