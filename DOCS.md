# Documentation Index

Complete guide to all FundMe project documentation. Start here!

## Getting Started (Start Here)

| Document                           | Purpose                                      | Time   |
| ---------------------------------- | -------------------------------------------- | ------ |
| **[README.md](README.md)**         | Project overview, features, and architecture | 5 min  |
| **[ONBOARDING.md](ONBOARDING.md)** | Step-by-step setup guide for developers      | 20 min |
| **[QUICKREF.md](QUICKREF.md)**     | Quick command reference and shortcuts        | 2 min  |

**Recommended path for new developers:**

1. Read README.md (understand what FundMe does)
2. Follow ONBOARDING.md (set up your environment)
3. Bookmark QUICKREF.md (daily reference)

---

## Core Documentation

### Project Information

- **[README.md](README.md)** - Complete project documentation
  - What is FundMe?
  - Features and technology stack
  - Installation and usage
  - Smart contract documentation
  - Testing and deployment guides

### Getting Started

- **[ONBOARDING.md](ONBOARDING.md)** - Comprehensive onboarding guide
  - Prerequisites and installation
  - Quick start (5 minutes)
  - Understanding the project
  - Development workflow
  - Common tasks
  - Testing strategy
  - Deployment guide
  - Troubleshooting

---

## Contributing & Development

### Contribution Guidelines

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
  - Code of conduct
  - Development setup
  - Making changes
  - Testing requirements
  - Submission process
  - Code style guide
  - Commit message format
  - Pull request process

### Security

- **[SECURITY.md](SECURITY.md)** - Security policies and practices
  - Security considerations
  - Implemented protections
  - Known risks and mitigations
  - Audit status
  - Vulnerability reporting
  - Best practices for users
  - Security resources

---

## Reference Documentation

### Development References

- **[QUICKREF.md](QUICKREF.md)** - Quick reference guide
  - Essential commands
  - File structure
  - Key addresses
  - Environment variables
  - Common test commands
  - Contract functions
  - Debugging tips
  - Gas estimates

## Code Organization

### Smart Contracts (`src/`)

- **FundMe.sol** - Main crowdfunding contract
  - `fund()` - Contribute funds
  - `withdraw()` - Owner withdrawal
  - View functions for querying state

- **PriceConverter.sol** - Price conversion library
  - ETH/USD conversion using Chainlink
  - Used by FundMe for validation

### Tests (`test/`)

- **unit/FundMeTest.t.sol** - Unit tests
  - Tests for all contract functions
  - 11+ test cases
  - Edge case coverage

- **integration/InteractionsTest.t.sol** - Integration tests
  - End-to-end scenarios
  - Multi-user workflows

### Scripts (`script/`)

- **DeployFundMe.s.sol** - Deployment orchestration
- **HelperConfig.s.sol** - Network configuration
- **Interactions.s.sol** - Contract interaction helpers

---

## Quick Start Paths

### I want to...

**...understand the project**

1. Read [README.md](README.md)
2. Review [Overview section](README.md#-overview)
3. Check [Smart Contracts section](README.md#-smart-contracts)

**...set up locally**

1. Follow [ONBOARDING.md](ONBOARDING.md#-quick-start-5-minutes)
2. Run `make install && make build && make test`
3. Reference [QUICKREF.md](QUICKREF.md) for commands

**...contribute code**

1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Follow [Development Workflow](CONTRIBUTING.md#-development-workflow)
3. Create a feature branch and make changes
4. Run tests with `make test`
5. Submit a pull request

**...deploy the contract**

1. Check [Deployment section](ONBOARDING.md#-deployment-guide) in ONBOARDING
2. Configure `.env` file
3. Run `make deploy-sepolia` for testnet
4. See [Deployment Guide](README.md#-deployment) for details

**...understand security**

1. Read [SECURITY.md](SECURITY.md)
2. Review [Security Considerations](README.md#-security-considerations)
3. Check known [vulnerabilities and mitigations](SECURITY.md#-potential-risks)

**...report an issue**

1. Check [FAQ.md](FAQ.md) for common issues
2. Search existing GitHub issues
3. For security: Email maintainers privately
4. For bugs: Open GitHub issue with details

**...get help**

1. Check [FAQ.md](FAQ.md)
2. Search [QUICKREF.md](QUICKREF.md) for commands
3. Review [Troubleshooting in ONBOARDING](ONBOARDING.md#-troubleshooting)
4. Open GitHub issue or discussion

---

## Documentation Map

```
 Documentation
├──  Quick Start
│   ├── README.md (overview)
│   ├── ONBOARDING.md (setup)
│   └── QUICKREF.md (commands)
│
├──  For Contributors
│   ├── CONTRIBUTING.md (guidelines)
│   ├── SECURITY.md (security)
│
│
└──  Administrative
    ├── LICENSE (MIT)
    └── .env.example (template)
```

---

## Learning Path

### Beginner

1. Read [README.md](README.md) overview
2. Review [ONBOARDING.md](ONBOARDING.md) completely
3. Run the quick start commands
4. Review test files to understand the contract

### Intermediate

1. Study [Smart Contracts section](README.md#-smart-contracts)
2. Read through source code in `src/`
3. Run tests and understand what they verify
4. Try deploying to Sepolia following [Deployment Guide](ONBOARDING.md#-deployment-guide)

### Advanced

1. Review [SECURITY.md](SECURITY.md) security considerations
2. Study Chainlink integration in detail
3. Explore gas optimization techniques
4. Review [ROADMAP.md](ROADMAP.md) for future improvements
5. Consider professional security audit

---

## External Resources

### Official Documentation

- [Foundry Book](https://book.getfoundry.sh/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Ethereum Development](https://ethereum.org/en/developers/)

### Tools & Services

- [Etherscan Block Explorer](https://etherscan.io/)
- [Sepolia Faucet](https://sepoliafaucet.com/)
- [Remix IDE](https://remix.ethereum.org/)
- [Alchemy](https://www.alchemy.com/) - RPC Provider

### Learning Resources

- [Smart Contract Security](https://www.secureum.xyz/)
- [Solidity By Example](https://solidity-by-example.org/)
- [DeFi Concepts](https://ethereum.org/en/developers/docs/intro-to-ethereum/)

---

## Support & Help

### Documentation Questions

- Search [QUICKREF.md](QUICKREF.md) for commands
- Review relevant section in [ONBOARDING.md](ONBOARDING.md)

### Technical Issues

- Check [Troubleshooting section](ONBOARDING.md#-troubleshooting)
- Review [SECURITY.md](SECURITY.md) for security issues
- Open GitHub issue with details

### Contributing Questions

- Read [CONTRIBUTING.md](CONTRIBUTING.md) completely
- Check [Code Style Guide](CONTRIBUTING.md#-code-style-guide)
- Ask in GitHub discussions

### Security Concerns

- **DO NOT** open public issues
- Email maintainers with vulnerability details
- Follow responsible disclosure practices
- See [SECURITY.md](SECURITY.md) for details

---

## Documentation Checklist

Before making changes, ensure:

- [ ] README.md is accurate
- [ ] ONBOARDING.md reflects current setup
- [ ] QUICKREF.md has latest commands
- [ ] SECURITY.md reflects current risks
- [ ] CONTRIBUTING.md is up to date

---

## Last Updated

- **README.md**: May 2026
- **ONBOARDING.md**: May 2026
- **CONTRIBUTING.md**: May 2026
- **SECURITY.md**: May 2026
- **QUICKREF.md**: May 2026
- **This document**: May 2026

---

## Ready to Get Started?

1. **New to FundMe?** → Start with [README.md](README.md)
2. **Setting up locally?** → Follow [ONBOARDING.md](ONBOARDING.md)
3. **Need quick reference?** → Check [QUICKREF.md](QUICKREF.md)
4. **Want to contribute?** → Read [CONTRIBUTING.md](CONTRIBUTING.md)

---

**Happy coding! **

This documentation index was created to help you navigate all FundMe documentation efficiently.
