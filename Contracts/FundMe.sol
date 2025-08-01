//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//Importing Library from NPM and Github

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; //Make it Constant because it doesn't need to change later in the code and this is more efficient.

    address[] private funders;
    
    mapping(address funder => uint256 amountFunded) private addressToAmountFunded;
    
    address public immutable i_owner;

    constructor()
    {
        i_owner = msg.sender;
    }


    function fund() public payable  
    {
        // Allow users to send money with minimum fund limit.
        // 1. How to send ETH to the Contract? 
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough eth"); //if the transaction fields the function will be reverted but still consume gas.
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        // 1e18 Wei = 1ETH = 1 * 10 ** 18 Wei.
    }
    // We Don't anyone the withdraw money from the contract we want only the owner of the contract to withdraw.
    // To not have to put the same require line to ensure that only the owner can call a function we intialize this modifier.

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "You Aren't An Admin.");
        if(msg.sender != i_owner) {revert NotOwner();}
        _; // To determine which to be executed first the function or the modifer.
    }
   
   
    function withdraw() public  onlyOwner{
        //require(msg.sender == i_owner); 

        // For loop/
        for(/*Starting Index, Ending Index, Step amount*/ uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }  
        funders = new address[](0); //resetting the array

        // 3 Different ways to send Native Blockchain currency from a contract.
        
        // Transfer
        // msg.sender = address, payable(msg.sender) = payable address.
        // Costs 2300 gas, if more gas is used it throws an error
        //payable(msg.sender).transfer(address(this).balance);
        
        // Send
        // Costs 2300 gas, if more gas is used it returns a boolean if it is succesful or not.
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed."); // This way if this fails it will still revert the transaction automatically if it fails.

        // Call (The Recommended Way!!)
        // First lower level commands we will use.
        // We can use it to call virtually any function in all of ethereum without having the API.
        // Costs all the gas, if the function fails it returns a boolean if it is succesful or not.
        (bool callSuccess, /*bytes memory dataReturned*/) = payable(msg.sender).call {value: address(this).balance} ("")/*We don't wanna call a function so will leave this blank.*/;
        require(callSuccess, "Call Failed.");
    }

    //Instead of All the requires in the functions we can create custom errors.
    //more gas efficient.

    //What happens if someone sends this contract ETH without calling the fund function?
    //We can create a fallback function to handle this.

    //recieve()
    receive() external payable {fund();}
    //fallback()
    fallback() external payable {fund();}

}