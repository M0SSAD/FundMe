# FundMe

FundMe is a Solidity smart contract project enabling decentralized ETH crowdfunding with secure owner withdrawals and transparent funding logic. The project is built using [Foundry](https://book.getfoundry.sh/) and integrates [Chainlink](https://chain.link/) price feeds for accurate ETH/USD conversion across networks.

## Overview

FundMe lets anyone contribute ETH to the contract, enforcing a minimum USD threshold for each contribution using live price data. Only the contract owner can withdraw funds, ensuring security. The project supports multiple EVM-compatible networks and offers robust automated testing.

## Key Features

- Open ETH funding, owner-only withdrawals
- Minimum funding enforced in USD, using Chainlink price feeds
- Multi-network deployment through modular configuration
- Secure withdrawal logic (checks-effects-interactions, custom errors, onlyOwner modifier)
- Receives direct ETH transfers via receive/fallback
- Comprehensive, cheatcode-powered testing (Foundry)
- Mock price feed interface for local tests

## Project Structure

- `src/`
  - `FundMe.sol`: Core contract for managing funding and withdrawals using live price data
  - `PriceConverter.sol`: Library for ETH/USD conversion via Chainlink

- `test/`
  - `FundMeTest.t.sol`: Full test suite covering funding logic, owner controls, price conversions, and edge cases
  - `MockV3Aggregator.sol`: Mock implementation of Chainlink price feed for reliable local testing

- `script/`
  - `HelperConfig.sol`: Provides network-specific configuration, including correct price feed address for local, testnet, and mainnet deployments
  - `DeployFundMe.s.sol`: Deployment script utilizing HelperConfig for correct setup

- `foundry.toml`
  - Project configuration and remappings for dependencies

## How HelperConfig Works

`HelperConfig.sol` is a key part of the deployment process. It determines which Chainlink price feed address to use based on the currently selected network. For local development, it will deploy a mock price feed (`MockV3Aggregator.sol`) and return its address. For testnets and mainnet, it provides the corresponding live Chainlink price feed address. This enables seamless, environment-aware deployments and testing without manual address changes.

Example flow:
- On local network: HelperConfig deploys `MockV3Aggregator`, returns its address.
- On testnet/mainnet: HelperConfig returns the official Chainlink price feed address.

## Mock Price Feed

`MockV3Aggregator.sol` is used in local development and testing to simulate Chainlink price feeds. This ensures that all logic relying on price data can be reliably tested without needing live data or network connectivity.

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js (optional, for scripts)

### Install Dependencies

```bash
forge install smartcontractkit/chainlink-brownie-contracts
forge install foundry-rs/forge-std
```

### Run Tests

```bash
forge test
```

### Deploy

Edit `HelperConfig.sol` for your target network and run deployment scripts from the `script/` directory.

## Contract Details

### FundMe.sol

- Accepts ETH funding, enforces minimum USD value
- Owner-only withdrawal
- Chainlink price feed integration
- Receive/fallback functions for direct ETH transfers

### PriceConverter.sol

- Fetches ETH/USD price
- Converts ETH amount to USD

### HelperConfig.sol (in script/)

- Chooses correct price feed address for current network
- Deploys mock feed for local, returns official address for testnet/mainnet

### MockV3Aggregator.sol (in test/)

- Simulates Chainlink price feed for local testing

## Testing

Covers:
- Minimum funding enforcement
- Owner-only withdrawal
- Price conversion accuracy (mock/live feeds)
- Secure ETH transfer handling

## Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Commit History](https://github.com/M0SSAD/FundMe/commits/main)

---

Author: [M0SSAD](https://github.com/M0SSAD)
