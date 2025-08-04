//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//Importing Library from NPM and Github
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256; // To use the functions in the PriceConverter library.

    AggregatorV3Interface private priceFeed; // To get the price of ETH in USDs.
    // We can use the interface to call the functions in the contract without importing the whole contract
    // and this is more gas efficient.
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; // 5 USD Is the minimum amount to fund.
    address[] public funders; // To keep track of all the funders.
    // We can use a mapping to store the amount funded by each address.
    // This is more gas efficient than using an array.
    // We can use the address of the funder as the key and the amount funded as the value.
    // This way we can easily get the amount funded by a specific address.
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    address public immutable i_owner; // The owner of the contract.

    constructor(address _priceFeedAddress) {
        i_owner = msg.sender; // The owner of the contract is the address that deploys the contract.
        priceFeed = AggregatorV3Interface(_priceFeedAddress); // Initialize the priceFeed with the address of the price feed contract.
        // This way we can use the functions in the AggregatorV3Interface to get the price of ETH in USDs.
    }

    function fund() public payable {
        // Allow users to send money with minimum fund limit.
        // 1. How to send ETH to the Contract?
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "didn't send enough eth"); // if the transaction fails the function will be reverted but still consume gas.
        funders.push(msg.sender); // To keep track of all the funders. 
        addressToAmountFunded[msg.sender] += msg.value; // To keep track of the amount funded by each address.
        // msg.value is the amount of ETH sent with the transaction.
        // msg.value is in Wei, which is the smallest unit of ETH.
        // 1 ETH = 10 ** 18 Wei.
        // So, to convert the amount sent in Wei to USD, we can use the getConversionRate function from the PriceConverter library.
        // The priceFeed is an instance of the AggregatorV3Interface which allows us to get the price of ETH in USDs.
        // The getConversionRate function takes the priceFeed as an argument to get the current price of ETH in USDs.
    }
    // We Don't anyone the withdraw money from the contract we want only the owner of the contract to withdraw.
    // To not have to put the same require line to ensure that only the owner can call a function we intialize this modifier.

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "You Aren't An Admin.");
        if (msg.sender != i_owner) revert FundMe__NotOwner(); // If the sender is not the owner of the contract, revert the transaction with a custom error.
        _; // To determine which to be executed first the function or the modifer.
    }

    function withdraw() public onlyOwner {

        // For loop/
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex]; // Get the address of the funder at the current index.
            addressToAmountFunded[funder] = 0; // Resetting the amount funded by each address to 0.
        }
        funders = new address[](0); //resetting the array
        /*
        --------------------------------------------------------------------------------------------------------------------------------------------
        3 Different ways to send Native Blockchain currency from a contract.

        1. Transfer
        msg.sender = address, payable(msg.sender) = payable address.
        Costs 2300 gas, if more gas is used it throws an error
        payable(msg.sender).transfer(address(this).balance);

        2. Send
        Costs 2300 gas, if more gas is used it returns a boolean if it is succesful or not.
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send Failed."); // This way if this fails it will still revert the transaction automatically if it fails.

        3. Call (The Recommended Way!!)
        First lower level commands we will use.
        We can use it to call virtually any function in all of ethereum without having the API.
        Costs all the gas, if the function fails it returns a boolean if it is succesful or not.
        --------------------------------------------------------------------------------------------------------------------------------------------
        */
        
        (bool callSuccess, /*bytes memory dataReturned*/ ) = payable(msg.sender).call{value: address(this).balance}(""); 
        // Using call to send the balance of the contract to the owner.
        // The empty string is to indicate that we are not calling any function in the contract.
        // The call function returns a boolean indicating if the call was successful or not.
        // We can also return the data returned by the function, but we don't need it in this case.
        // The call function is more gas efficient than transfer and send, and it is the recommended way to send native currency in Solidity.
        // It is also more flexible as it allows us to call any function in any contract.
        // However, we need to be careful when using call as it can lead to re-entrancy attacks if not used properly.

        // To prevent re-entrancy attacks, we should always update the state of the contract before calling an external contract 
        // and we should use the checks-effects-interactions pattern.

        // The checks-effects-interactions pattern is a design pattern that helps prevent re-entrancy
        // attacks by ensuring that we check the conditions of the contract, update the state of the contract,
        // and then interact with external contracts in that order.

        // In this case, we first reset the amount funded by each address and then reset the funders array
        // before calling the external contract to send the balance of the contract to the owner.

        // This way, we ensure that the state of the contract is updated before interacting with the external contract.
        // If the call fails, we revert the transaction with a custom error message.
        require(callSuccess, "Call Failed.");
    }


    //What happens if someone sends this contract ETH without calling the fund function?
    // We can use the receive and fallback functions to handle this case.
    // The receive function is called when the contract receives ETH without any data.
    // The fallback function is called when the contract receives ETH with data or when the function called does not exist.
    // We can use these functions to call the fund function and allow users to send ETH to the contract without calling the fund function explicitly.
    // This way, we can ensure that the contract can receive ETH and the fund function is called automatically.

    //receive()
    receive() external payable {
        fund();
    }
    //fallback()
    fallback() external payable {
        fund();
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    } // To get the version of the price feed contract.
}
