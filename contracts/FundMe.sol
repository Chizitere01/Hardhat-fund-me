// SPDX-License-Identifier: MIT

// Get funds from users
// Withdraw funds
//Set a minimum funding value in USD

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";
// "constant" keyword and "immutable" keyword help to reduce gas

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;

    address private immutable i_owner;

    AggregatorV3Interface public s_priceFeed;

    // constructor function is the function that automatically gets called when we deploy our contract
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD
        //1. how do we send ETh to this contract?
        //Payable keywird is added to the function to make it fir to transact funds

        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough"
        ); // 1e18 == 1*10 **18 == 1000000000000000000
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
        //msg.value is going to have 18 decimal places
        // require keyword is a checker, it says: is msg.value greater than 1? if not it will revert and send the red message
        // What is reverting?
        // Undo any action before, and send remaining gas back
    }

    // the code in the comment below is used to get the get the version of interfaces
    // function getVersion() public view returns (uint256) {
    //     // ETH/USD price feed address of Sepolia Network.
    //     AggregatorV3Interface s_priceFeed = AggregatorV3Interface(
    //         0x694AA1769357215DE4FAC081bf1f309aDC325306
    //     );
    //     return s_priceFeed.version();
    // }

    function withdraw() public onlyOwner {
        //for loop
        //[1, 2, 3, 4]
        /* starting index, ending index, step amount*/
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            //code
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0); // this is to reset the array
        /*
        now to actually withdraw the funds
        //transfer,
        //msg.sender = address
        //payable(msg.sender) = payable address
        payable(msg.sender).transfer(address(this).balance);

        //send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);  
        require(sendSuccess, "Send failed"); */

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function cheaperWithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        //mappings can't be in memory
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Sender is not Owner!");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        } // this also saves gas
        _;
    }

    // what if someone sends this contract ETH without calling the fund function?
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(
        address funder
    ) public view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
