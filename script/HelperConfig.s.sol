//SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on local anvil chain
// 2. Keep track of contract address accross different chains

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //if we are on a local chain we want to deploy mocks.
    //Otherwise, we want to use the existing price feed address.

    struct NetworkConfig {
        address priceFeed;
    }
    
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    NetworkConfig public activeNetworkConfig;


    constructor() {
        if (block.chainid == 1) {
            //Mainnet
            activeNetworkConfig = getEthMainnetConfig();
        } else if (block.chainid == 11155111) {
            //Sepolia Testnet
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 31337) {
            //Anvil Localhost
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        } else {
            revert("No Active Network Config Found");
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // Price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        // Price feed address
        NetworkConfig memory mainnetConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //price feed address
        if (activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        //1. Deploy a mock price feed contract
        //2. Return the mock price feed address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }
}
