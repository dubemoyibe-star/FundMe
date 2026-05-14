# FundMe Project Onboarding Guide

Welcome to the FundMe smart contract project! This guide will help you get up and running quickly.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Understanding the Project](#understanding-the-project)
4. [Development Workflow](#development-workflow)
5. [Common Tasks](#common-tasks)
6. [Testing Strategy](#testing-strategy)
7. [Deployment Guide](#deployment-guide)
8. [Troubleshooting](#troubleshooting)
9. [Next Steps](#next-steps)

## Prerequisites

Before you start, ensure you have:

### Required Software

- **Foundry** - Ethereum development framework

  ```bash
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
  ```

- **Git** - Version control

  ```bash
  # Check if installed
  git --version
  ```

- **WSL2** (Windows) or Linux/Mac terminal
  - Foundry works best in Unix-like environments

### Optional but Recommended

- **Node.js** v16+ for additional tooling
- **VS Code** with Solidity extension
- **MetaMask** or similar wallet for testnet interaction
- **Alchemy/Infura** account for testnet RPC endpoints

##  Quick Start (5 minutes)

### Step 1: Clone and Install

```bash
# Clone the repository
git clone https://github.com/your-username/foundry-fund-me.git
cd foundry-fund-me

# Install dependencies
make install

# Verify installation
forge --version
```

### Step 2: Run Tests

```bash
# Run all tests
make test

# Expected output: All tests should pass ✓
```

### Step 3: Build the Project

```bash
# Compile smart contracts
make build

# Verify compilation succeeded
```

### Step 4: Explore Locally

```bash
# Start local blockchain
make anvil

# In another terminal, deploy locally
make deploy-local
```

**Congratulations!** You've successfully set up the project locally.

---

##  Understanding the Project

### What is FundMe?

FundMe is a decentralized crowdfunding contract where:

- Users can deposit ETH to contribute to a campaign
- A minimum USD-equivalent threshold is enforced
- Only the contract owner can withdraw collected funds
- Chainlink price feeds ensure USD-denominated minimums

### Architecture Overview

```
┌─────────────────────────────────────────┐
│         FundMe Contract                 │
├─────────────────────────────────────────┤
│ • Tracks funders and their amounts      │
│ • Enforces minimum USD threshold        │
│ • Owner-based withdrawal control        │
└─────────────────┬───────────────────────┘
                  │
         ┌────────▼────────┐
         │ PriceConverter  │
         │ (Library)       │
         └────────┬────────┘
                  │
         ┌────────▼──────────────────┐
         │ Chainlink Price Feed      │
         │ (ETH/USD Oracle)          │
         └───────────────────────────┘
```

### File Purposes

| File                         | Purpose                        |
| ---------------------------- | ------------------------------ |
| `src/FundMe.sol`             | Main contract logic            |
| `src/PriceConverter.sol`     | Price conversion library       |
| `script/DeployFundMe.s.sol`  | Deployment orchestration       |
| `script/HelperConfig.s.sol`  | Network-specific configuration |
| `test/unit/FundMeTest.t.sol` | Unit tests                     |
| `Makefile`                   | Development commands           |

---

## Development Workflow

### Daily Development Cycle

#### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

#### 2. Make Changes

Edit Solidity files in `src/` directory:

```solidity
// Example: Adding a new function
function newFunction() public returns (uint256) {
    // Your code here
}
```

#### 3. Format Code

```bash
make format
# or
forge fmt
```

#### 4. Run Tests

```bash
# Run all tests
make test

# Run specific test
forge test --match testFunctionName -vvv

# Run with specific fork
make test-fork
```

#### 5. Commit and Push

```bash
git add .
git commit -m "feat: add new functionality"
git push origin feature/your-feature-name
```

#### 6. Create Pull Request

Open PR on GitHub with:

- Clear description of changes
- Link to relevant issues
- Test results

---

## Common Tasks

### Task: Understand the Code Flow

1. **Read the main contract**: `src/FundMe.sol`
   - Understand state variables
   - Trace the `fund()` function
   - Examine `withdraw()` logic

2. **Read the library**: `src/PriceConverter.sol`
   - See how prices are fetched
   - Understand conversion calculation

3. **Check deployment script**: `script/DeployFundMe.s.sol`
   - See contract initialization

### Task: Add a New Function

Example: Add a function to check if an address is a funder

```solidity
// In FundMe.sol
function isFunder(address _address) public view returns (bool) {
    return s_addressToAmountFunded[_address] > 0;
}
```

Then:

1. Add unit test in `test/unit/FundMeTest.t.sol`
2. Run `make test` to verify
3. Format with `make format`

### Task: Deploy to Testnet

```bash
# Set environment variables in .env
export SEPOLIA_RPC_URL="your_rpc_url"
export ETHERSCAN_API_KEY="your_key"

# Deploy
make deploy-sepolia
```

### Task: Verify on Etherscan

```bash
forge verify-contract \
  <contract_address> \
  src/FundMe.sol:FundMe \
  --chain sepolia \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" 0x694AA1769357215DE4FAC081bf1f309adC325306)
```

---

## Testing Strategy

### Test Structure

```
test/
├── unit/
│   └── FundMeTest.t.sol         # Core functionality tests
└── integration/
    └── InteractionsTest.t.sol   # End-to-end scenarios
```

### Writing Tests

#### Basic Test Structure

```solidity
function testFunctionName() public {
    // Arrange - set up test conditions
    uint256 initialValue = 100;

    // Act - execute the function
    fundMe.someFunction(initialValue);

    // Assert - verify results
    assertEq(fundMe.getValue(), initialValue);
}
```

#### Using Modifiers

```solidity
modifier funded() {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    _;
}

function testWithdraw() public funded {
    // Test code here
}
```

#### Common Test Patterns

```solidity
// Check state changes
assertEq(actual, expected);

// Check reverts
vm.expectRevert();
fundMe.fund{value: 0.001 ether}();

// Check events
vm.expectEmit(true, true, true, true);
emit Funded(USER, SEND_VALUE);
fundMe.fund{value: SEND_VALUE}();

// Impersonate addresses
vm.prank(someAddress);
fundMe.someFunction();

// Deal test funds
vm.deal(USER, 10 ether);
```

### Running Tests

```bash
# All tests
forge test

# Specific test
forge test --match testMinimumDollarIsFive

# Verbose output (more details)
forge test -vv

# Very verbose (includes contract calls)
forge test -vvv

# With coverage
forge coverage

# With gas reports
forge test --gas-report
```

---

## Deployment Guide

### Local Development (Anvil)

```bash
# Terminal 1: Start Anvil
make anvil

# Terminal 2: Deploy
make deploy-local

# Get contract address from output
# Now you can interact with it!
```

### Sepolia Testnet

#### Prerequisites

1. **Wallet with Sepolia ETH**
   - Get Sepolia ETH from: https://sepoliafaucet.com

2. **Environment Variables** (.env)

   ```env
   SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY
   ETHERSCAN_API_KEY=your_etherscan_key
   ```

3. **Funded Account**
   - Ensure your wallet has enough Sepolia ETH for gas

#### Deployment Steps

```bash
# 1. Build
make build

# 2. Deploy
make deploy-sepolia

# 3. Note the contract address from output
# Contract deployed to: 0x...

# 4. Wait for confirmation (check Etherscan)
# https://sepolia.etherscan.io/address/0x...

# 5. Interact with contract
make fund
make withdraw
```

### After Deployment

1. **Note the address**

   ```bash
   # Save this for reference
   CONTRACT_ADDRESS=0x...
   ```

2. **View on Etherscan**
   - https://sepolia.etherscan.io/address/$CONTRACT_ADDRESS

3. **Interact via Cast**

   ```bash
   # Call a function
   cast call $CONTRACT_ADDRESS "getOwner()" \
     --rpc-url $SEPOLIA_RPC_URL

   # Send transaction
   cast send $CONTRACT_ADDRESS "fund()" \
     --value 0.01ether \
     --private-key $PRIVATE_KEY \
     --rpc-url $SEPOLIA_RPC_URL
   ```

---

## Troubleshooting

### Issue: "Command not found: forge"

**Solution:**

```bash
# Reinstall Foundry
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc  # or ~/.zshrc for Mac
foundryup
```

### Issue: Tests fail locally but environment seems fine

**Solution:**

```bash
# Clear cache and rebuild
make clean
make build
make test
```

### Issue: "Error: Invalid price" in PriceConverter

**Solution:**

- Price feed address might be incorrect for the network
- Check `HelperConfig.s.sol` for correct addresses
- Verify network connectivity

### Issue: Deployment fails with "Invalid sender nonce"

**Solution:**

```bash
# May have stale nonce, try again in a moment
# Or clear the broadcast cache:
rm -rf broadcast/
```

### Issue: "Compiler version not found"

**Solution:**

```bash
# Update Foundry
foundryup
```

---

## Next Steps

After completing this onboarding, consider:

### Short Term (This Week)

- [ ] Read through `src/FundMe.sol` line by line
- [ ] Understand the test suite
- [ ] Deploy to local Anvil successfully
- [ ] Run all tests and verify they pass

### Medium Term (This Month)

- [ ] Deploy to Sepolia testnet
- [ ] Interact with deployed contract
- [ ] Write a new test case
- [ ] Add a new feature to the contract

### Long Term (This Quarter)

- [ ] Understand Chainlink integration deeply
- [ ] Explore gas optimization techniques
- [ ] Consider security audit
- [ ] Build a frontend for the contract

---

## Helpful Resources

### Documentation

- [Foundry Book](https://book.getfoundry.sh/) - Official guide
- [Solidity Docs](https://docs.soliditylang.org/) - Language reference
- [Chainlink Docs](https://docs.chain.link/) - Oracle integration
- [Ethereum Basics](https://ethereum.org/en/developers/) - Blockchain fundamentals

### Tools & Services

- [Sepolia Faucet](https://sepoliafaucet.com) - Get test ETH
- [Etherscan](https://sepolia.etherscan.io/) - Block explorer
- [Alchemy Dashboard](https://www.alchemy.com/) - RPC provider
- [Remix IDE](https://remix.ethereum.org/) - Online Solidity IDE

### Learning Materials

- Understand [Smart Contract Security](https://www.secureum.xyz/)
- [Solidity Pattern](https://solidity-patterns.readthedocs.io/)
- [DeFi Concepts](https://www.paradigm.xyz/)

---

## FAQ

**Q: Do I need testnet ETH to deploy?**  
A: Yes, you need Sepolia ETH. Get it free from faucets.

**Q: Can I modify the contract after deployment?**  
A: No, smart contracts are immutable. Deploy a new version if needed.

**Q: How do I debug failing tests?**  
A: Use `forge test -vvv` for verbose output and add `console.log()` statements.

**Q: Where do I ask questions?**  
A: Open issues on GitHub or check the discussions section.

---

## Getting Help

- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Ask questions in GitHub Discussions
- **Discord**: Join Foundry Discord for community support

---

**Welcome aboard! Happy coding! **

Last updated: May 2026
