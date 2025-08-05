//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../../src/FundMe.sol";

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user"); // Create a user address for testing purposes.
    uint256 constant SEND_VALUE = 1 * 10 ** 18;
    uint256 constant USER_BALANCE = 10 * 10 ** 18; // User's initial balance
    uint256 constant GAS_PRICE = 1; // Set a gas price for the transaction

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, USER_BALANCE); // Fund the user with some ETH
    }

    function testUserCanFundInteractions() external {
        uint256 userIntialBalance = address(fundMe).balance;
        FundFundMe fundFundMe = new FundFundMe();// Set the user as the sender // Ensure the user has enough balance
        fundFundMe.fundFundMe(address(fundMe));
        uint256 fundedBalance = address(fundMe).balance - userIntialBalance;
        assertEq(fundedBalance, SEND_VALUE); // Check if the contract balance is equal to the sent value
       
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0); // Check if the contract balance is zero after withdrawal
    }

}