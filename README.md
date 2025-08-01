# FundMe

FundMe is a Solidity-based smart contract project, initially designed to facilitate the management of contributions and withdrawals on an Ethereum-compatible blockchain network. This project serves as a foundational step in learning and applying blockchain development principles.

## Project Overview

### FundMe Smart Contract
The FundMe contract enables users to contribute Ether (ETH) to a smart contract. Only the contract owner is authorized to withdraw the accumulated funds. This contract demonstrates foundational concepts in Solidity, such as access control, state management, and secure fund handling.

### PriceConverter Utility
The repository also includes the `PriceConverter.sol` contract, which provides utility functions for currency conversion. It is typically used to convert ETH amounts to their USD equivalent based on live price feeds. This contract enhances the FundMe contract by enabling validation of minimum funding amounts and supporting price-based logic.

## Chainlink Price Feed Integration

The `PriceConverter.sol` contract utilizes Chainlink Price Feeds to obtain the current ETH to USD conversion rate. By integrating Chainlink, the FundMe contract can reliably validate whether a contribution meets the minimum USD threshold, regardless of ETH's market volatility. This ensures accurate and up-to-date conversion for all contributions.

### Key Benefits of Chainlink Price Feeds:
- Decentralized and secure access to real-time price data.
- Accurate conversion of ETH value to USD within smart contracts.
- Enhanced reliability for minimum funding logic in the FundMe contract.

## Structure

- **contracts/**: Contains Solidity smart contracts.
  - `FundMe.sol`: Manages contributions and withdrawals.
  - `PriceConverter.sol`: Supplies ETH-to-USD conversion utilities using Chainlink price feeds.

## Usage

### FundMe Contract
1. Deploy `FundMe.sol` to an Ethereum-compatible network.
2. Contribute ETH by sending funds to the contract address.
3. Only the contract owner can withdraw the total balance.

### PriceConverter Contract
- Used internally by `FundMe.sol` to check conversion rates and validate minimum funding requirements.
- Leverages Chainlink price feeds for accurate and decentralized price data.
- Can be reused in other Solidity contracts that require price conversion functionality.

## Technologies Used

- Solidity (100%) for smart contract logic.
- Chainlink Price Feeds for decentralized price data.

## License

This project is licensed under the MIT License.
