# FundMe

FundMe is a simple smart contract project developed in Solidity as part of my journey to learn Blockchain development. This repository demonstrates the fundamentals of decentralized finance by allowing users to contribute funds and enabling the contract owner to withdraw them.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

FundMe is designed to help beginners understand the basics of smart contract development, including fund management, access control, and deployment on the Ethereum blockchain. The contract allows anyone to send ETH to the contract address, while only the owner can withdraw the total balance.

## Features

- Accepts ETH from any user
- Stores contributor addresses and amounts
- Owner-only withdrawal functionality
- Simple and transparent fund management

## Getting Started

To get started with FundMe, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/M0SSAD/FundMe.git
   cd FundMe
   ```

2. **Install dependencies:**
   You’ll need [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/) installed.
   ```bash
   npm install
   ```

3. **Compile the smart contract:**
   Use [Hardhat](https://hardhat.org/) or your preferred Solidity development environment.
   ```bash
   npx hardhat compile
   ```

4. **Deploy the contract:**
   Configure your deployment script and run:
   ```bash
   npx hardhat run scripts/deploy.js --network <network_name>
   ```

## Project Structure

- `contracts/` – Contains Solidity smart contracts
- `scripts/` – Deployment and interaction scripts
- `test/` – Unit tests for the smart contract
- `README.md` – Project documentation

## Technologies Used

- **Solidity:** Smart contract programming language
- **Hardhat:** Development environment for Ethereum software
- **JavaScript:** Used for deployment and testing scripts

## Usage

After deploying the contract, users can send ETH to the contract address. The contract keeps track of all contributors and their respective contributions. Only the owner of the contract can withdraw the accumulated funds.

Example interaction:
1. Send ETH to the contract address using MetaMask or another wallet.
2. The owner calls the `withdraw` function to retrieve the funds.

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes
4. Open a pull request describing your improvements

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

For any questions or feedback, feel free to open an issue.
