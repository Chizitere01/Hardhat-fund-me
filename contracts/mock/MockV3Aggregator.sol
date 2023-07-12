// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract MockV3Aggregator is AggregatorV3Interface {
    uint256 private constant _VERSION = 0;

    uint8 public override decimals;
    int256 public latestAnswer;
    uint256 public latestTimestamp;
    uint256 public latestRound;

    mapping(uint256 => int256) public getAnswer;
    mapping(uint256 => uint256) public getTimestamp;
    mapping(uint256 => uint256) private getStartedAt;

    constructor(uint8 _decimals, int256 _initialAnswer) public {
        decimals = _decimals;
        updateAnswer(_initialAnswer);
    }

    function updateAnswer(int256 _answer) public {
        latestAnswer = _answer;
        latestTimestamp = block.timestamp;
        latestRound++;
        getAnswer[latestRound] = _answer;
        getTimestamp[latestRound] = block.timestamp;
        getStartedAt[latestRound] = block.timestamp;
    }

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = _roundId;
        answer = getAnswer[_roundId];
        startedAt = getStartedAt[_roundId];
        updatedAt = getTimestamp[_roundId];
        answeredInRound = uint80(_roundId);
    }

    function latestRoundData()
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = uint80(latestRound);
        answer = getAnswer[latestRound];
        startedAt = getStartedAt[latestRound];
        updatedAt = getTimestamp[latestRound];
        answeredInRound = uint80(latestRound);
    }

    function description() external view override returns (string memory) {
        return "v0.6/tests/MockV3Aggregator.sol";
    }

    function version() external view override returns (uint256) {
        return _VERSION;
    }
}
