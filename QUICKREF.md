# Quick Reference Guide

Quick commands and references for FundMe development.

## Essential Commands

```bash
# Installation
make install              # Install all dependencies
make build               # Build the project
make clean               # Clean build artifacts

# Development
make test                # Run all tests
make test-fork           # Run tests with Sepolia fork
make format              # Format code
make anvil               # Start local blockchain

# Deployment
make deploy-local        # Deploy to Anvil
make deploy-sepolia      # Deploy to Sepolia testnet

# Interaction
make fund                # Fund the contract
make withdraw            # Withdraw funds (owner)
```

## File Structure Quick Reference

```
src/
├── FundMe.sol           # Main contract (CORE)
└── PriceConverter.sol   # Price library

script/
├── DeployFundMe.s.sol   # Deployment orchestration
├── HelperConfig.s.sol   # Network configuration
└── Interactions.s.sol   # Interaction scripts

test/
├── unit/
│   └── FundMeTest.t.sol       # Unit tests
└── integration/
    └── InteractionsTest.t.sol # Integration tests
```

## Key Addresses

### Sepolia Testnet

- **ETH/USD Price Feed**: `0x694AA1769357215DE4FAC081bf1f309adC325306`
- **Anvil Default Account**: `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`

### Mainnet

- **ETH/USD Price Feed**: `0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419`

## Environment Variables

```bash
# Required
SEPOLIA_RPC_URL         # Sepolia RPC endpoint
ETHERSCAN_API_KEY       # For contract verification

```

## Common Test Commands

```bash
# Run all tests
forge test

# Run specific test
forge test --match testFunctionName

# Run with verbose output
forge test -vvv

# Run with gas report
forge test --gas-report

# Run specific file
forge test --match-path "test/unit/FundMeTest.t.sol"

# Run with coverage
forge coverage
```

## Contract Functions

### FundMe.sol

| Function                            | Type    | Access | Purpose                |
| ----------------------------------- | ------- | ------ | ---------------------- |
| `fund()`                            | Payable | Public | Contribute funds       |
| `withdraw()`                        | State   | Owner  | Withdraw all funds     |
| `getVersion()`                      | View    | Public | Get price feed version |
| `getOwner()`                        | View    | Public | Get contract owner     |
| `getFundersLength()`                | View    | Public | Get funder count       |
| `getFunder(uint256)`                | View    | Public | Get funder address     |
| `getAddressToAmountFunded(address)` | View    | Public | Get funder amount      |

### PriceConverter.sol

| Function                              | Type          | Purpose            |
| ------------------------------------- | ------------- | ------------------ |
| `getPrice(address)`                   | Internal View | Get ETH/USD price  |
| `getConversionRate(uint256, address)` | Internal View | Convert ETH to USD |

## Debugging

### Common Issues & Solutions

```bash
# Issue: Command not found: forge
# Solution:
foundryup

# Issue: Tests fail
# Solution:
make clean && make build && make test

# Issue: Deployment fails
# Solution:
# 1. Check .env file
# 2. Verify RPC URL
# 3. Check account balance
# 4. Try again (nonce issue)

# Issue: Price feed error
# Solution:
# 1. Verify price feed address
# 2. Check network
# 3. Check RPC connection
```

## Gas Estimates

| Operation         | Gas Cost   | Notes                   |
| ----------------- | ---------- | ----------------------- |
| Deploy            | ~1,000,000 | One-time                |
| Fund (first time) | ~60,000    | Adds funder to array    |
| Fund (repeat)     | ~40,000    | Updates amount only     |
| Withdraw          | ~100,000+  | Depends on funder count |

## Important Links

- **GitHub**: https://github.com/oyibe/foundry-fund-me
- **Foundry Docs**: https://book.getfoundry.sh/
- **Chainlink Docs**: https://docs.chain.link/
- **Sepolia Faucet**: https://sepoliafaucet.com
- **Etherscan**: https://sepolia.etherscan.io/

## Development Checklist

Before submitting code:

- [ ] Code is formatted (`make format`)
- [ ] All tests pass (`make test`)
- [ ] No compiler warnings
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] No sensitive data in code

## Documentation Files

- `README.md` - Project overview
- `ONBOARDING.md` - Getting started guide
- `CONTRIBUTING.md` - Contributing guidelines
- `SECURITY.md` - Security policies
- `QUICKREF.md` - This file

## Quick Help

```bash
# View Foundry help
forge --help
forge test --help
cast --help

# View contract ABI
forge inspect src/FundMe.sol:FundMe abi

# Get account balance
cast balance 0xAddress --rpc-url $RPC_URL

# Decode transaction data
cast calldata "fund()"
```

## Emergency Commands

```bash
# Clear all cache and rebuild
make clean
cargo clean  # If Foundry install is corrupted
foundryup    # Reinstall Foundry

# Force contract verification
forge verify-contract $ADDRESS src/FundMe.sol:FundMe \
  --chain sepolia \
  --constructor-args $(cast abi-encode "constructor(address)" $PRICE_FEED)
```

---

**Bookmark this page for quick reference during development!** 📌

Last Updated: May 2026
