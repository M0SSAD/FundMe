//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../../src/FundMe.sol";

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user"); // Create a user address for testing purposes.
    uint256 constant SEND_VALUE = 1 * 10 ** 18;
    uint256 constant USER_BALANCE = 10 * 10 ** 18; // User's initial balance
    uint256 constant GAS_PRICE = 1; // Set a gas price for the transaction

    modifier funded() { // Fund the contract with enough ETH before running the test
        vm.prank(USER);
        vm.deal(USER, USER_BALANCE);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    modifier gasCalc() {
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        _;
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log("Gas used:", gasUsed);
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // console.log("FundMe contract deployed at:", address(fundMe));
        // console.log("DeployFundMe contract address is:", address(deployFundMe));
        // console.log("Msg.sender is:", msg.sender);
    }

    function testMinimumUsd() public {
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public {
        address owner = fundMe.getOwner();
        console.log("Owner of the contract is:", owner);
        console.log("Address of the contract is:", address(this));
        assertEq(owner, msg.sender);
    }

    //What can we do to work with addresses outside our system?
    // 1. Unit Test
    //   - Testing a specific part of our code.
    // 2. Integration Test
    //   - Testing how our code works with other parts of our code.
    // 3. Forked Test
    //   - Testing our code on a simulated real environment.
    // 4. Staging Test
    //   - Testing our code in a real environment that is not production.

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert("didn't send enough eth"); // Expect the revert message
        fundMe.fund(); // Try to fund with less than minimum USD
        assertEq(fundMe.getAddressToAmountFunded(address(this)), 0); // Ensure
    }

    function testFundSuccess() public payable funded {// Use the funded modifier to ensure the function is called with enough ETH
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE);
        assertEq(fundMe.getFunder(0), USER);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0); 
        assertEq(funder, USER);
    }
    

    function testOnlyOwnerCanWithdraw() public funded { // Ensure the function is called with right privileges
        vm.expectRevert("FundMe__NotOwner()"); // Expect the revert message
        vm.prank(USER); // Simulate a transaction from USER
        fundMe.cheaperWithdraw(); // Try to withdraw as USER
    }

    function testWithdrawWithSingleFunder() public funded {
        // Arrange
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialFundMeBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner()); // Simulate a transaction from the owner
        fundMe.cheaperWithdraw();
        // Assert
        assertEq(fundMe.getOwner().balance, initialOwnerBalance + initialFundMeBalance);
        assertEq(address(fundMe).balance, 0);   
    }

    function testWithdrawWithMultipleFundersCheaper() public funded gasCalc {
        
        // Arrange
        uint256  numberOfFunders = 10; // Number of funders to simulate
        uint256 startingFunderIndex = 1;
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        
        for(uint256 i = startingFunderIndex; i < numberOfFunders; i++)
        {
            address funder = address(uint160(i + 1)); // Create a new funder address
            hoax(funder, USER_BALANCE); // Simulate the funder with enough balance
            fundMe.fund{value: SEND_VALUE}(); // Fund the contract
        }

        uint256 initialFundMeBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner()); // Simulate a transaction from the owner (costs 200 gas)
        fundMe.cheaperWithdraw();
        // Assert
        assertEq(fundMe.getOwner().balance, initialOwnerBalance + initialFundMeBalance);
        assertEq(address(fundMe).balance, 0);
    }

}
