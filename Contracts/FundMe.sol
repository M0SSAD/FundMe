//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//Importing Library from NPM and Github

import {PriceConverter} from "./PriceConverter.sol";


contract FundMe {

     using PriceConverter for uint256;
    
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    address[] public funders;
    
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    
    function fund() public payable  
    {
        // Allow users to send money with minimum fund limit.
        // 1. How to send ETH to the Contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough eth"); //if the transaction fields the function will be reverted but still consume gas.
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        // 1e18 Wei = 1ETH = 1 * 10 ** 18 Wei.
    }

    function withdraw() public  {
        // For loop/
        for(/*Starting Index, Ending Index, Step amount*/ uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;

        }  

        funders = new address[](0); //resetting the array

    }
}