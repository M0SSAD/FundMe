//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//Importing Library from NPM and Github
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    
    
    function getPrice() internal view returns(uint256) {
        //Address of The contract of chainlink to get the Current Price.
        //0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF ETH/USD zkSync Sepolia testnet address

        //API of the Contract.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
            );
        
        (, int256 answer, , , ) = priceFeed.latestRoundData(); //Price of ETH in terms of USD
       
        return uint256(answer * 1e10); // To match answer with msg.value we multiplie it by 1e10 to make them 18 decimals.
        //type casting the int256 answer to uint256 to be like msg.value.

    } // to get the price of ETH in USDs
    function getConversionRate(uint256 ethAmount) internal  view returns (uint256) {
        //1 ETH = 2000,000000000000000000
        uint256 ethPrice = getPrice();
        // for N ETH -> (2000,000000000000000000 * N,000000000000000000) / 1e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; //Always multiplie before dividing
        return ethAmountInUsd;
    } // To convert the msg.value in terms of dollars using getPrice().

    function getVersion() internal view returns(uint256) {
      return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
     } //to test The interface 
      
}