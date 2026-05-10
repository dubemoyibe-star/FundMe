# FundMe - Decentralized Crowdfunding Smart Contract

> A production-ready Solidity smart contract for decentralized crowdfunding built with Foundry, featuring Chainlink price feeds for USD-denominated minimum funding thresholds.

![Solidity](https://img.shields.io/badge/Solidity-^0.8.18-blue)
![Foundry](https://img.shields.io/badge/Foundry-Latest-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Smart Contracts](#smart-contracts)
- [Testing](#testing)
- [Deployment](#deployment)
- [Key Concepts](#key-concepts)
- [Security Considerations](#security-considerations)
- [Gas Optimization](#gas-optimization)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Overview

FundMe is a decentralized crowdfunding platform built on Ethereum. It allows users to contribute funds to a campaign while ensuring a minimum USD-denominated contribution threshold. The contract leverages Chainlink's price feeds to maintain USD-equivalent minimum thresholds, making it blockchain-agnostic to ETH price volatility.

Only the contract owner can withdraw the collected funds, ensuring a simple but effective access control model.

## Features

- **USD-Denominated Minimums**: Uses Chainlink price feeds to convert ETH amounts to USD values
- **Owner-Based Withdrawal**: Only the contract owner can withdraw collected funds
- **Funder Tracking**: Maintains a list of all funders and their contribution amounts
- **Event Logging**: Emits events for funding and withdrawal actions
- **Fallback Functions**: Accepts ETH through fallback and receive functions
- **Gas Optimized**: Uses immutable variables and efficient storage patterns
- **Comprehensive Testing**: Full unit and integration test coverage
- **Production Ready**: Audited patterns and best practices

## Project Structure

```
foundry-fund-me/
├── src/
│   ├── FundMe.sol              # Main crowdfunding contract
│   └── PriceConverter.sol       # Library for ETH/USD conversion
├── script/
│   ├── DeployFundMe.s.sol       # Deployment script
│   ├── HelperConfig.s.sol       # Network configuration
│   └── Interactions.s.sol       # Interaction scripts
├── test/
│   ├── unit/
│   │   └── FundMeTest.t.sol     # Unit tests
│   └── integration/
│       └── InteractionsTest.t.sol # Integration tests
├── lib/
│   ├── chainlink-evm/           # Chainlink contracts
│   ├── forge-std/               # Foundry standard library
│   └── foundry-devops/          # Development utilities
├── broadcast/                   # Deployment records
├── foundry.toml                 # Foundry configuration
├── Makefile                     # Development commands
└── README.md                    # This file
```

## 🛠 Technology Stack

| Technology    | Purpose                         |
| ------------- | ------------------------------- |
| **Solidity**  | Smart contract language         |
| **Foundry**   | Development framework & testing |
| **Chainlink** | Price feed oracle               |
| **Ethereum**  | Blockchain network              |
| **Sepolia**   | Testnet for deployment          |

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- [Git](https://git-scm.com/) installed
- An Ethereum wallet with Sepolia testnet funds (for deployment)
- [Node.js](https://nodejs.org/) v16+ (optional, for additional tooling)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/foundry-fund-me.git
   cd foundry-fund-me
   ```

2. **Install dependencies**

   ```bash
   make install
   ```

   This will install:
   - Chainlink EVM contracts
   - Foundry standard library
   - Foundry devops utilities

3. **Set up environment variables**

   ```bash
   cp .env.example .env
   ```

   Edit `.env` and configure:

   ```env
   # Required for Sepolia deployment
   SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
   ETHERSCAN_API_KEY=your_etherscan_api_key

   # Private key of deployment wallet (KEEP SECURE!)
   PRIVATE_KEY=your_private_key_here
   ```

4. **Build the project**
   ```bash
   make build
   ```

## Usage

### Running Tests

```bash
# Run all tests with verbose output
make test

# Run tests with fork simulation
make test-fork

# Run specific test file
forge test --match-path "test/unit/FundMeTest.t.sol" -vvv

# Run with coverage
forge coverage
```

### Local Development

```bash
# Start local Anvil blockchain
make anvil

# In another terminal, deploy to Anvil
make deploy-local
```

### Interact with Contract

```bash
# Fund the contract with 0.01 ETH
make fund

# Withdraw all funds (owner only)
make withdraw
```

### Format Code

```bash
# Format all Solidity files
make format
```

## Smart Contracts

### FundMe.sol

The main crowdfunding contract with the following functions:

#### Public Functions

| Function       | Description                                           |
| -------------- | ----------------------------------------------------- |
| `fund()`       | Contribute ETH with minimum USD threshold enforcement |
| `withdraw()`   | Withdraw all funds to owner address (owner only)      |
| `getVersion()` | Get Chainlink price feed version                      |

#### View Functions

| Function                            | Returns   | Description                    |
| ----------------------------------- | --------- | ------------------------------ |
| `getOwner()`                        | `address` | Contract owner address         |
| `getFundersLength()`                | `uint256` | Total number of unique funders |
| `getFunder(uint256)`                | `address` | Address of funder at index     |
| `getAddressToAmountFunded(address)` | `uint256` | Total amount funded by address |

#### State Variables

- `MINIMUM_USD`: Minimum required funding amount (5 USD in wei)
- `i_owner`: Contract owner (immutable)
- `chainLinkAddress`: Chainlink price feed address
- `s_addressToAmountFunded`: Mapping of funder addresses to amounts
- `s_funders`: Array of all funder addresses

#### Events

```solidity
event Funded(address indexed funder, uint256 amount);
event Withdrawn(address indexed owner, uint256 amount);
```

### PriceConverter.sol

A library for converting ETH amounts to USD values using Chainlink price feeds.

#### Functions

- `getPrice(address)`: Get current ETH/USD price from Chainlink
- `getConversionRate(uint256, address)`: Convert ETH amount to USD equivalent

## Testing

The project includes comprehensive tests covering:

### Unit Tests (`test/unit/FundMeTest.t.sol`)

- Minimum USD requirement enforcement
- Owner verification
- Funding amount tracking
- Funder array management
- Withdrawal functionality
- Access control

### Integration Tests (`test/integration/InteractionsTest.t.sol`)

- End-to-end funding workflows
- Multi-user scenarios
- Contract interactions

**Test Coverage:**

- 11+ unit test cases
- All critical paths covered
- Edge cases included

Run tests:

```bash
forge test -vvv
```

## Deployment

### Sepolia Testnet

Deploy to the Sepolia testnet:

```bash
make deploy-sepolia
```

This will:

1. Build the contract
2. Deploy to Sepolia
3. Verify on Etherscan
4. Store deployment records in `broadcast/`

### Local Anvil

For local testing:

```bash
make deploy-local
```

### Manual Deployment

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe \
  --rpc-url $SEPOLIA_RPC_URL \
  --account myWallet \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  -vvvv
```

## Key Concepts

### Price Feeds

This contract uses Chainlink's Aggregator V3 Interface to fetch real-time ETH/USD price data. The price is fetched on-chain and used to validate that contributions meet the minimum USD threshold.

**Price Feed Addresses:**

- Sepolia ETH/USD: `0x694AA1769357215DE4FAC081bf1f309adC325306`
- Mainnet ETH/USD: `0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419`

### Owner Access Control

The contract uses a simple but effective owner-based access control pattern:

- Owner is set during deployment
- Only owner can withdraw funds
- Owner check via custom error `FundMe__NotOwner()`

### Gas Optimization

- **Immutable variables**: `i_owner` saves gas on every access
- **Private storage**: `s_addressToAmountFunded` and `s_funders` are private
- **Events**: Used for off-chain data storage instead of state variables
- **View functions**: Provide efficient data access without state changes

## Security Considerations

### Audit Status

- ✅ Common vulnerability patterns checked
- ✅ Reentrancy guards (safe withdrawal pattern)
- ✅ Integer overflow protection (Solidity 0.8.18+)

### Best Practices Implemented

1. **Check-Effects-Interactions Pattern**: Withdrawal follows CEI pattern
2. **Immutable Owner**: Owner cannot be changed after deployment
3. **Event Logging**: All significant actions emit events
4. **Input Validation**: Minimum USD threshold enforced
5. **Safe Transfer**: Uses low-level call with success check

### Potential Improvements

- [ ] Consider timelock for withdrawal
- [ ] Implement emergency pause functionality
- [ ] Add per-user withdrawal capability
- [ ] Support multiple price feeds

## Gas Optimization

Current gas optimizations:

1. **Immutable Variables**: `i_owner` stored as immutable (saves ~2000 gas per access)
2. **Private Storage**: Private state variables (saves gas on access)
3. **Efficient Loops**: Funder array reset uses assignment
4. **Event Logging**: Off-chain data storage without state overhead

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure:

- Code is formatted with `forge fmt`
- All tests pass: `forge test`
- No new warnings or errors
- Documentation is updated

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Documentation**: [Foundry Book](https://book.getfoundry.sh/)
- **Chainlink Docs**: [Chainlink Price Feeds](https://docs.chain.link/data-feeds/price-feeds)
- **Issues**: Open an issue on GitHub
- **Discussions**: GitHub Discussions

## Acknowledgments

- [Foundry](https://getfoundry.sh/) - Development framework
- [Chainlink](https://chain.link/) - Price feed oracle
- [Ethereum](https://ethereum.org/) - Blockchain platform
- [OpenZeppelin](https://openzeppelin.com/) - Security patterns

---

**Built with ❤️ using Foundry**
