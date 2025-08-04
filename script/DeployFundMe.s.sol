//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol"; // Importing the FundMe contract to deploy it.
import {Script} from "forge-std/Script.sol"; // Importing Script from forge-std to use the startBroadcast and stopBroadcast functions.
import {HelperConfig} from "./HelperConfig.s.sol"; // Importing HelperConfig to get the price feed address for the FundMe contract.

contract DeployFundMe is Script {
    FundMe fundMe;

    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig(); // Create an instance of HelperConfig to get the active network configuration.
        // This will automatically set the price feed address based on the network we are on.
        (address priceFeedAddress) = helperConfig.activeNetworkConfig(); // Get the price feed address from the active network configuration.
        vm.startBroadcast(); // Start broadcasting the transaction to deploy the contract.
        fundMe = new FundMe(priceFeedAddress); // Deploy the FundMe contract with the price feed address.
        vm.stopBroadcast();
        return fundMe;
    } // This function deploys the FundMe contract and returns the instance of the deployed contract.
    // The run function is the entry point for the script when executed.
}
