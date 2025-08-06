# FundMe: A Solidity & Foundry Learning Project

## Overview

FundMe is a decentralized crowdfunding smart contract built with Solidity and the Foundry framework. This project serves as a comprehensive introduction to smart contract development, testing, and deployment using modern Ethereum tooling. It demonstrates essential concepts including contract ownership, ETH funding with USD validation, Chainlink oracle integration, secure withdrawals, and industry-standard testing practices.

## Features

- **Crowdfunding Contract**: Allows users to fund the contract with ETH while enforcing a minimum USD value requirement
- **Chainlink Price Feed Integration**: Uses Chainlink oracles to convert ETH to USD for accurate minimum funding validation
- **Ownership and Access Control**: Implements secure owner-only withdrawal functionality with custom error handling
- **Gas-Optimized Operations**: Features both standard and gas-efficient withdrawal methods (`withdraw()` and `cheaperWithdraw()`)
- **Receive and Fallback Functions**: Handles direct ETH transfers to the contract address by routing them to the fund() function
- **Multi-Network Support**: Configured for deployment on local Anvil, Ethereum Sepolia, and zkSync Sepolia testnets
- **AI-Generated Frontend**: Complete web interface built with HTML, CSS, and JavaScript for contract interaction
- **Comprehensive Testing**: Includes unit and integration tests using Foundry's testing utilities and cheatcodes
- **Fork Testing**: Supports testing against live networks using Foundry's forking capabilities
- **Automated Scripts**: Provides deployment and interaction scripts for streamlined contract management

## Project Structure

```
src/                    # Solidity smart contracts
├── FundMe.sol         # Main crowdfunding contract
└── PriceConverter.sol # Library for ETH/USD price conversion

test/                   # Foundry test suite
├── unit/
│   └── FundMeTest.t.sol    # Unit tests for FundMe contract
├── integration/
│   └── InteractionTest.t.sol # Integration tests
└── mocks/
    └── MockV3Aggregator.sol  # Mock price feed for testing

script/                 # Deployment and interaction scripts
├── DeployFundMe.s.sol # Contract deployment script
├── HelperConfig.s.sol # Network configuration helper
└── interactions.s.sol # Funding and withdrawal scripts

<<<<<<< HEAD
frontend/               # AI-generated web interface
├── index.html         # Main frontend interface
├── index.js           # Web3 integration logic
├── constants.js       # Contract configuration
├── ethers-6.7.esm.min.js # Ethers.js library
└── connect.png        # UI assets

lib/                    # External dependencies
├── chainlink-brownie-contracts/  # Chainlink interfaces
├── forge-std/         # Foundry standard library
└── foundry-devops/    # DevOps utilities

=======
>>>>>>> 08ea90a48d748bccd9db72ed17e885cd39a1c935
foundry.toml           # Foundry configuration and remappings
Makefile               # Automated build and deployment tasks
```

## Smart Contracts

### FundMe.sol

The main contract that handles crowdfunding operations:

- **Constructor**: Accepts a Chainlink price feed address for flexible deployment across networks
- **fund()**: Allows users to contribute ETH with minimum USD value validation (minimum $5 USD equivalent)
- **withdraw()**: Owner-only function for withdrawing all contract funds using standard method
- **cheaperWithdraw()**: Gas-optimized withdrawal method that reduces gas costs by minimizing storage reads
- **receive()** and **fallback()**: Handle direct ETH transfers by automatically routing to fund() function
- **getVersion()**: Returns the Chainlink price feed contract version for debugging and verification
- **Access Control**: Uses custom errors and onlyOwner modifier for secure operations
- **Funder Tracking**: Maintains arrays and mappings to track all funders and their contribution amounts

### PriceConverter.sol

A library providing ETH to USD conversion utilities:

- **getPrice()**: Fetches current ETH price from Chainlink price feed
- **getConversionRate()**: Converts ETH amount to USD equivalent
- **Integration**: Works with AggregatorV3Interface for reliable price data

## Frontend Interface

This project includes a **fully AI-generated frontend** built with HTML, CSS, and JavaScript to interact with the deployed FundMe smart contract. The frontend provides a user-friendly interface for testing and demonstrating the contract's functionality.

### Frontend Features

- **Contract Interaction**: Direct integration with MetaMask for seamless blockchain interactions
- **Funding Interface**: Simple form to fund the contract with ETH amount validation
- **Real-time Updates**: Live display of contract balance and funding status
- **Withdrawal Controls**: Owner-only withdrawal functionality with proper access control
- **Network Support**: Compatible with local Anvil network and Ethereum testnets
- **Responsive Design**: Mobile-friendly interface with modern CSS styling
- **Error Handling**: Comprehensive error messages and transaction status feedback

### Frontend Structure

```
frontend/
├── index.html          # Main interface with contract interaction forms
├── index.js            # JavaScript for Web3 integration and contract calls
├── constants.js        # Contract ABI and address configuration
├── ethers-6.7.esm.min.js # Ethers.js library for blockchain interaction
├── connect.png         # UI assets and images
└── README.md           # Frontend-specific documentation
```

### Key Frontend Components

- **Connection Management**: Automatic MetaMask detection and wallet connection
- **Contract Integration**: Direct calls to FundMe contract functions (fund, withdraw, getters)
- **Balance Display**: Real-time contract balance and funder information
- **Transaction Feedback**: Success/error notifications for all contract interactions
- **Owner Controls**: Special interface elements for contract owner operations

### Running the Frontend

1. **Start local blockchain**:
   ```bash
   anvil
   ```

2. **Deploy the contract**:
   ```bash
   make deploy
   ```

3. **Update contract configuration**:
   - Copy the deployed contract address
   - Update `contractAddress` in `frontend/constants.js`

4. **Serve the frontend**:
   ```bash
   cd frontend
   # Use any local server
   python -m http.server 8080
   # Or use live-server, http-server, or VS Code Live Server
   ```

5. **Connect MetaMask**:
   - Add Anvil network (Chain ID: 31337, RPC: http://127.0.0.1:8545)
   - Import an Anvil account using the private key
   - Navigate to `http://localhost:8080` to access the interface

### AI-Generated Frontend

**Important Note**: The entire frontend (HTML, CSS, and JavaScript) was **100% generated using AI** to demonstrate rapid prototyping capabilities and showcase how AI can accelerate full-stack dApp development. This includes:

- **Responsive UI Design**: Complete styling and layout generated through AI prompts
- **Web3 Integration**: All blockchain interaction code written by AI using Ethers.js
- **Error Handling**: Comprehensive exception handling and user feedback systems
- **Modern JavaScript**: ES6+ features and async/await patterns implemented by AI
- **UX/UI Patterns**: Industry-standard interface patterns and user experience flows
- **Contract Integration**: Automatic ABI usage and contract method calling

This demonstrates the potential of AI-assisted development in creating functional, professional-grade frontends for blockchain applications without manual coding.

### Frontend Learning Outcomes

- **Web3 Integration**: Understanding how to connect frontend applications to smart contracts
- **MetaMask Integration**: Implementing wallet connectivity and transaction signing
- **Contract ABI Usage**: Utilizing contract ABIs for frontend-blockchain communication
- **Ethers.js Library**: Working with modern Web3 libraries for blockchain interaction
- **Error Handling**: Managing blockchain transaction errors and user feedback
- **Responsive Design**: Creating mobile-friendly dApp interfaces
- **AI-Assisted Development**: Leveraging AI tools for rapid frontend prototyping and development

## Testing Framework

### Unit Tests
- Comprehensive coverage of all contract functions and edge cases
- Mock price feed integration for reliable local testing independent of external services
- Foundry cheatcodes for address simulation and balance manipulation (`vm.deal`, `vm.prank`, `hoax`)
- Gas usage tracking and optimization validation
- Multi-funder scenarios testing with address generation and funding simulation
- Owner validation and access control testing

### Integration Tests
- End-to-end testing of funding and withdrawal workflows using actual deployment scripts
- Multi-funder scenarios and edge case handling
- Network-specific testing with actual Chainlink price feeds using fork testing
- Real deployment interaction testing through script contracts
- Balance assertion testing accounting for pre-existing contract balances

### Fork Testing
- Tests against live Ethereum Sepolia testnet using `--fork-url` parameter
- Validates contract behavior with real Chainlink price feed data
- Ensures compatibility with actual network conditions and gas prices

### Test Utilities
- **vm.deal()**: Assigns ETH balances to test addresses
- **vm.prank()**: Simulates transactions from specific addresses
- **hoax()**: Combines address creation with balance assignment
- **Mock contracts**: Ensure consistent testing environment

## Scripts and Automation

### DeployFundMe.s.sol
- Automated contract deployment across different networks
- Integration with HelperConfig for network-specific settings
- Transaction broadcasting and verification

### HelperConfig.s.sol
- Network configuration management (local, testnet, mainnet)
- Automatic mock deployment for local testing
- Chainlink price feed address mapping by network

### interactions.s.sol
- **FundFundMe**: Script for funding the deployed contract
- **WithdrawFundMe**: Script for owner withdrawal operations
- **DevOpsTools integration**: Automatic detection of most recent deployment

## Configuration

### foundry.toml
```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
remappings = [
    "@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/"
]
```

### Makefile

The project includes a comprehensive Makefile that automates common development tasks and simplifies complex commands:

#### Setup and Maintenance
- `make install`: Installs all required dependencies (foundry-devops, chainlink-brownie-contracts, forge-std)
- `make update`: Updates all Foundry dependencies to latest versions
- `make clean`: Cleans build artifacts and cache
- `make build`: Compiles all contracts
- `make format`: Formats Solidity code using Forge formatter

#### Testing
- `make test`: Runs the complete test suite
- `make snapshot`: Generates gas usage snapshots for optimization tracking
- `make zktest`: Runs tests on zkSync compatibility mode

#### Local Development
- `make anvil`: Starts local Anvil blockchain with predefined mnemonic and settings
- `make zk-anvil`: Starts zkSync local development node

#### Deployment
- `make deploy`: Deploys to local Anvil network
- `make deploy-sepolia`: Deploys to Ethereum Sepolia testnet with verification
- `make deploy-zk`: Deploys to local zkSync network
- `make deploy-zk-sepolia`: Deploys to zkSync Sepolia testnet

#### Contract Interaction
- `make fund`: Funds the deployed contract (requires SENDER_ADDRESS configuration in Makefile)
- `make withdraw`: Withdraws funds from the contract (owner only, requires SENDER_ADDRESS configuration)

#### Environment Configuration
The Makefile uses environment variables and automatically selects network configurations:
- Supports `--network sepolia` flag for automatic testnet deployment
- Uses account management for secure key handling (requires local account setup)
- Includes Etherscan verification for deployed contracts (requires ETHERSCAN_API_KEY)
- **Note**: Users must configure their own environment variables and account management

### Network Support
- **Local**: Anvil blockchain with mock price feeds for development and testing
- **Testnet**: Ethereum Sepolia with live Chainlink ETH/USD price feeds
- **zkSync Sepolia**: Alternative testnet with zkSync-specific price feed addresses
- **Mainnet**: Production Ethereum with live Chainlink feeds (configured but not recommended for learning)

## Getting Started

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Git for version control
- Basic understanding of Solidity and blockchain concepts
- **Local Development Setup**: Configure Foundry accounts or environment variables for private keys
- **Network Access**: RPC URLs for desired networks (Sepolia, zkSync, etc.)
- **Optional**: Etherscan API key for contract verification

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/M0SSAD/FundMe.git
   cd FundMe
   ```

2. **Install dependencies**:
   ```bash
   # Using Foundry directly
   forge install
   
   # Or using Makefile (recommended)
   make install
   ```

3. **Build contracts**:
   ```bash
   # Using Foundry directly
   forge build
   
   # Or using Makefile
   make build
   ```

4. **Run tests**:
   ```bash
   # Using Foundry directly
   forge test
   forge test -vv  # Verbose output
   forge test --gas-report  # Gas usage analysis
   forge test --fork-url $SEPOLIA_RPC_URL  # Fork testing against live network
   
   # Or using Makefile
   make test
   make snapshot  # Generate gas snapshots
   ```

### Local Development

1. **Start Anvil (local blockchain)**:
   ```bash
   # Using Foundry directly
   anvil
   
   # Or using Makefile (with custom configuration)
   make anvil
   ```

2. **Deploy to local network**:
   ```bash
   # Using Foundry directly (configure your own account management)
   forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --account <YOUR_ACCOUNT>
   
   # Or using Makefile
   make deploy
   ```

### Deployment

1. **Local deployment**:
   ```bash
   # Using Foundry directly
   forge script script/DeployFundMe.s.sol
   
   # Or using Makefile
   make deploy
   ```

2. **Testnet deployment**:
   ```bash
   # Using Foundry directly (requires environment variables or account setup)
   forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
   
   # Or using Makefile (recommended - includes verification, requires account configuration)
   make deploy-sepolia
   ```

### Interaction

1. **Fund the contract**:
   ```bash
   # Using Foundry directly - testnet deployment (requires environment variables)
   forge script script/interactions.s.sol:FundFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
   
   # Using Foundry directly - local deployment (replace with actual deployed contract address)
   forge script script/interactions.s.sol:FundFundMe --rpc-url http://127.0.0.1:8545 --broadcast --sig "fundFundMe(address)" 0xYourContractAddress
   
   # Using Makefile (requires SENDER_ADDRESS configuration in Makefile)
   make fund
   ```

2. **Withdraw funds** (owner only):
   ```bash
   # Using Foundry directly - testnet deployment (requires environment variables)
   forge script script/interactions.s.sol:WithdrawFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
   
   # Using Foundry directly - local deployment
   forge script script/interactions.s.sol:WithdrawFundMe --rpc-url http://127.0.0.1:8545 --broadcast --sig "withdrawFundMe(address)" 0xYourContractAddress
   
   # Using Makefile (requires SENDER_ADDRESS configuration in Makefile)
   make withdraw
   ```

### Troubleshooting

- **DevOpsTools read errors in broadcast mode**: Pass contract addresses directly to scripts instead of using `get_most_recent_deployment`
- **VS Code Solidity import errors**: Restart the Solidity language server or update workspace settings for proper remapping recognition
- **Fork test failures**: Ensure `SEPOLIA_RPC_URL` environment variable is set correctly
- **Gas estimation errors**: Use `forge clean` to clear artifacts and rebuild contracts
- **Account management**: Configure Foundry accounts using `cast wallet` or set up environment variables for private keys
- **Environment variables**: Create a `.env` file with required variables like `SEPOLIA_RPC_URL`, `PRIVATE_KEY`, `ETHERSCAN_API_KEY`
- **Makefile configuration**: Update SENDER_ADDRESS and other variables in the Makefile according to your setup

## Learning Outcomes

This project demonstrates mastery of:

- **Solidity Fundamentals**: Contract structure, state variables, functions, modifiers, and custom errors
- **Security Best Practices**: Access control, input validation, secure ETH transfers, and checks-effects-interactions pattern
- **Oracle Integration**: Chainlink price feeds for reliable external data and USD conversion logic
- **Testing Methodology**: Unit and integration testing with Foundry, including fork testing against live networks
- **Development Workflow**: Building, testing, and deploying with modern Foundry tooling and cheatcodes
- **Gas Optimization**: Efficient coding patterns, storage optimization, and multiple withdrawal implementations
- **Script Automation**: Deployment and interaction automation with error handling
- **Frontend Development**: AI-assisted web interface creation using HTML, CSS, JavaScript, and Ethers.js
- **Full-Stack dApp Development**: Complete blockchain application from smart contracts to user interface
- **Project Organization**: Professional project structure, comprehensive documentation, and dependency management
- **Network Configuration**: Multi-network deployment strategies and environment-specific configurations
- **Debugging Skills**: Troubleshooting common Foundry and Solidity development issues
- **AI-Assisted Development**: Leveraging AI tools for rapid prototyping and accelerated development workflows

## Security Considerations

- **Access Control**: Owner-only withdrawal with proper validation
- **Input Validation**: Minimum funding requirements and zero-value checks
- **External Calls**: Safe handling of Chainlink price feed interactions
- **Reentrancy Protection**: Secure withdrawal patterns
- **Error Handling**: Custom errors for gas-efficient reverts

## Technologies Used

- **Solidity ^0.8.18**: Smart contract programming language
- **Foundry**: Development framework for testing and deployment
- **Chainlink**: Decentralized oracle network for price feeds
- **OpenZeppelin**: Security standards and best practices
- **DevOps Tools**: Automated deployment and interaction utilities

## License

This project is licensed under the MIT License.

---

**Note**: This project is designed for educational purposes and demonstrates fundamental blockchain development concepts. It should not be used in production environments without comprehensive security audits and additional testing.
