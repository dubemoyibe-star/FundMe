# Contributing to FundMe

Thank you for your interest in contributing to FundMe! We welcome contributions from the community. This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Code Style Guide](#code-style-guide)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Security Issues](#security-issues)
- [Questions](#questions)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

- Be respectful and inclusive
- Welcome newcomers and help them get oriented
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

1. **Fork the Repository**

   ```bash
   # Click "Fork" button on GitHub
   ```

2. **Clone Your Fork**

   ```bash
   git clone https://github.com/YOUR_USERNAME/foundry-fund-me.git
   cd foundry-fund-me
   ```

3. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/foundry-fund-me.git
   ```

## Development Setup

1. **Install Prerequisites**

   ```bash
   # Foundry
   curl -L https://foundry.paradigm.xyz | bash
   foundryup

   # Git
   git --version
   ```

2. **Install Project Dependencies**

   ```bash
   make install
   ```

3. **Verify Setup**
   ```bash
   make build
   make test
   ```

## Making Changes

### Create a Feature Branch

```bash
# Update main branch
git checkout main
git pull upstream main

# Create new branch
git checkout -b feature/your-feature-name
```

**Branch naming conventions:**

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `test/` - Test improvements
- `refactor/` - Code refactoring
- `perf/` - Performance improvements

### Make Your Changes

1. **Edit files** in appropriate directories
   - Smart contracts: `src/`
   - Tests: `test/`
   - Scripts: `script/`
   - Documentation: Root directory

2. **Write clear, documented code**

   ```solidity
   /// @notice Funds the contract with ETH
   /// @dev Requires minimum USD threshold
   /// @param _amount The amount to fund
   function fund(uint256 _amount) public payable {
       // Implementation
   }
   ```

3. **Keep commits focused**
   - One logical change per commit
   - Avoid mixing refactoring with new features

## Testing

### Before Submitting

All changes must pass tests:

```bash
# Run all tests
make test

# Run with coverage
forge coverage

# Format code
make format

# Check for warnings
forge build
```

### Writing Tests

Tests should:

- Have clear, descriptive names
- Follow AAA pattern (Arrange, Act, Assert)
- Cover happy path and edge cases
- Include both unit and integration tests

```solidity
function testFundingWithMinimumAmount() public {
    // Arrange
    uint256 fundAmount = 0.01 ether;
    vm.deal(USER, fundAmount);

    // Act
    vm.prank(USER);
    fundMe.fund{value: fundAmount}();

    // Assert
    assertEq(fundMe.getAddressToAmountFunded(USER), fundAmount);
}

function testFundingBelowMinimumReverts() public {
    // Arrange & Act & Assert
    vm.expectRevert();
    fundMe.fund{value: 0.001 ether}();
}
```

## Submitting Changes

### Before Opening PR

1. **Sync with upstream**

   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push to your fork**

   ```bash
   git push origin feature/your-feature-name
   ```

3. **Ensure all checks pass**
   - Tests pass locally
   - Code is formatted
   - No new warnings

### Open a Pull Request

**PR Title Format:**

```
[Type] Short description

Examples:
[Feature] Add funder emergency withdrawal
[Fix] Correct price feed timeout issue
[Docs] Update deployment guide
```

**PR Description:**

```markdown
## Description

Brief explanation of changes

## Related Issue

Closes #123

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] All tests pass

## Checklist

- [ ] Code follows style guidelines
- [ ] Code formatted with `forge fmt`
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

## Code Style Guide

### Solidity Code Style

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Interface} from "path/to/Interface.sol";

/// @title Brief contract description
/// @notice What the contract does for users
/// @dev Development notes
contract MyContract {
    // ============ Type Declarations ============

    // ============ State Variables ============

    // Constants
    uint256 public constant CONSTANT_NAME = 100;

    // Immutable
    address private immutable i_owner;

    // Regular storage
    mapping(address => uint256) private s_balances;

    // ============ Events ============

    event Transfer(address indexed from, address indexed to, uint256 amount);

    // ============ Errors ============

    error MyContract__Unauthorized();

    // ============ Modifiers ============

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert MyContract__Unauthorized();
        _;
    }

    // ============ Constructor ============

    constructor(address owner) {
        i_owner = owner;
    }

    // ============ External Functions ============

    function transfer(address to, uint256 amount) external {
        // Implementation
    }

    // ============ Internal Functions ============

    function _internalHelper() internal {
        // Implementation
    }

    // ============ View Functions ============

    function getBalance(address account) external view returns (uint256) {
        return s_balances[account];
    }
}
```

### Naming Conventions

- **Constants**: `CONSTANT_NAME`
- **Immutable variables**: `i_variableName`
- **Private/Internal state**: `s_variableName` (storage) or regular name
- **Function parameters**: `_parameterName`
- **Local variables**: `localVariableName`
- **Custom errors**: `ContractName__ErrorDescription`
- **Events**: `PascalCase`

### Documentation Comments

```solidity
/// @notice Explanation for users
/// @dev Implementation details
/// @param paramName Description of parameter
/// @return Description of return value
function myFunction(uint256 paramName) external returns (uint256) {
    // Implementation
}
```

## Commit Messages

Use clear, descriptive commit messages:

```
[Type] Brief description

Longer explanation if needed. Explain WHAT and WHY, not HOW.

Closes #123
```

**Types:**

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `test:` - Test changes
- `refactor:` - Code refactoring
- `perf:` - Performance improvement
- `chore:` - Maintenance

**Examples:**

```
feat: add emergency withdrawal function for funders

fix: correct ETH/USD price precision calculation

docs: update README with deployment instructions

test: add test for funder array reset
```

## Pull Request Process

1. **Create PR** with descriptive title and description
2. **Address feedback** from reviews
3. **Keep PR focused** - don't mix unrelated changes
4. **Update documentation** if needed
5. **Ensure CI passes** - all checks must be green
6. **Maintainers merge** after approval

### Review Process

- At least one approval required
- All tests must pass
- No merge conflicts
- Code style guidelines followed
- Documentation updated

## Security Issues

**Do not** open public GitHub issues for security vulnerabilities!

Instead:

1. Email security concerns to the maintainers
2. Include steps to reproduce if possible
3. Allow time for a fix before public disclosure
4. Follow responsible disclosure practices

## Questions

Have questions? Several ways to get help:

- **GitHub Discussions** - Ask community questions
- **GitHub Issues** - Report bugs or request features
- **Pull Request** - Discuss specific code changes
- **Email** - Contact maintainers directly for sensitive topics

## Learning Resources

To contribute effectively, you may want to understand:

- [Foundry Development](https://book.getfoundry.sh/)
- [Solidity Language](https://docs.soliditylang.org/)
- [Ethereum Basics](https://ethereum.org/en/developers/)
- [Gas Optimization](https://github.com/Grafy-eth/Grafy/wiki/Gas-Optimization)
- [Smart Contract Security](https://www.secureum.xyz/)

## Thank You

Thank you for contributing to FundMe! Your efforts help make this project better for everyone.

---

Happy contributing!
