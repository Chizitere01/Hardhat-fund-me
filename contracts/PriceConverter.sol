// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // we are going to need two things
        // the ABI and
        // the address 0x447Fd5eC2D383091C22B8549cb231a3bAD6d3fAf
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(
        //     0x447Fd5eC2D383091C22B8549cb231a3bAD6d3fAf
        // );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // ETH in terms of USD
        return uint256(price * 1e10); // 1**10 == 10000000000
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
