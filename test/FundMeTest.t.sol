//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";

import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        console.log("FundMe contract deployed at:", address(fundMe));
        console.log("DeployFundMe contract address is:", address(deployFundMe));
        console.log("Msg.sender is:", msg.sender);
    }

    function testMinimumUsd() public {
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public {
        address owner = fundMe.i_owner();
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

    function testFund() public payable {
        uint256 value = 6 * 10 ** 18;
        vm.deal(address(this), value);
        vm.startPrank(address(this));
        fundMe.fund{value: value}();
        vm.stopPrank();
        assertEq(fundMe.addressToAmountFunded(address(this)), value);
        assertEq(fundMe.funders(0), address(this));
    }
}
