//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe  is Script {
     //Fund
    uint256 constant SEND_VALUE = 1 * 10 ** 18; // Amount to fund the contract with
    function fundFundMe(address mostRecentDeployed) public { // This function is called to fund the contract
        require(mostRecentDeployed != address(0), "Invalid contract address"); // Ensure
        vm.startBroadcast(); // Start broadcasting the transaction
        FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}(); // Call the fund function of the FundMe contract with the specified value
        vm.stopBroadcast();
        console.log("Funded FundMe with %s wei", SEND_VALUE);
    }
    function run() external { // This function is called when the script is run
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid); // Get the most recent deployment of the FundMe contract
        fundFundMe(mostRecentDeployed);
    }


}

contract WithdrawFundMe is Script {
    //Withdraw
    function withdrawFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).cheaperWithdraw();
        vm.stopBroadcast();
    }
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentDeployed);
    }

}
