# Security Policy

## Security Considerations

This document outlines security practices for the FundMe project and how to report security vulnerabilities.

## Supported Versions

| Version | Supported       |
| ------- | --------------- |
| 1.0.x   | ✅ Current      |
| < 1.0   | ⚠️ Updates only |

## Known Security Patterns

This contract implements known secure patterns:

### Implemented Protections

1. **Reentrancy Protection**
   - Uses Checks-Effects-Interactions (CEI) pattern
   - Withdrawal occurs after state updates
   - Safe low-level call with success check

   ```solidity
   // Safe pattern used
   s_addressToAmountFunded[funder] = 0;  // Effect
   s_funders = new address[](0);         // Effect
   (bool callSuccess, ) = payable(msg.sender).call{
       value: address(this).balance
   }("");  // Interaction
   require(callSuccess, "Call failed");
   ```

2. **Integer Overflow/Underflow**
   - Protected by Solidity 0.8.18+ built-in checks
   - Automatic revert on overflow/underflow

3. **Access Control**
   - Owner-based access control with custom error
   - Only owner can withdraw funds
   - Immutable owner address prevents unauthorized changes

   ```solidity
   error FundMe__NotOwner();

   modifier onlyOwner() {
       if (msg.sender != i_owner) revert FundMe__NotOwner();
       _;
   }
   ```

4. **Input Validation**
   - Minimum USD threshold enforced
   - Chainlink price validation (requires positive price)

### Potential Risks

1. **Oracle Price Feed Risk**
   - Depends on Chainlink price feed accuracy
   - No stale price check implemented
   - **Recommendation**: Add timestamp validation for production

   ```solidity
   // Consider adding in production:
   function getPrice(address chainLinkAddress) internal view returns (uint256) {
       AggregatorV3Interface priceFeed = AggregatorV3Interface(chainLinkAddress);
       (uint80 roundID, int256 answer, , uint256 updatedAt, ) = priceFeed.latestRoundData();

       require(answer > 0, "Invalid price");
       require(updatedAt >= block.timestamp - 1 hour, "Stale price feed");

       return uint256(answer * 10000000000);
   }
   ```

2. **Front-Running Risk**
   - Users' transactions could be reordered in mempool
   - **Mitigation**: Use private mempools or MEV protection services

3. **Fund Loss Scenarios**
   - Contract destruction not possible (no `selfdestruct`)
   - But funds could be permanently locked if owner key is lost
   - **Recommendation**: Implement timelock or multi-sig for withdrawal

4. **No Pause Mechanism**
   - Contract cannot be paused in emergency
   - **Recommendation**: Add emergency pause for production

### Chainlink Integration

The contract uses Chainlink's decentralized price feed:

```solidity
AggregatorV3Interface priceFeed = AggregatorV3Interface(chainLinkAddress);
(, int256 answer, , , ) = priceFeed.latestRoundData();
```

**Supported Networks:**

- **Sepolia**: `0x694AA1769357215DE4FAC081bf1f309adC325306` (ETH/USD)
- **Mainnet**: `0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419` (ETH/USD)

**References:**

- [Chainlink Price Feeds](https://docs.chain.link/data-feeds/price-feeds/)
- [Chainlink Addresses](https://docs.chain.link/data-feeds/price-feeds/addresses)

## Audit Status

This contract has **NOT** been formally audited. For production use:

- [ ] Conduct professional security audit
- [ ] Use formal verification tools
- [ ] Implement additional protections
- [ ] Deploy with reduced risk parameters

### Recommended Audit Companies

- [OpenZeppelin](https://www.openzeppelin.com/security-audit)
- [Trail of Bits](https://www.trailofbits.com/)
- [Consensys Diligence](https://consensys.net/)
- [Certora](https://www.certora.com/)

## Reporting Vulnerabilities

### IMPORTANT: DO NOT open public GitHub issues for security vulnerabilities

If you discover a security vulnerability, please report it responsibly:

1. **Do NOT** create a public GitHub issue
2. **Email** the maintainers with:
   - Vulnerability description
   - Steps to reproduce (if applicable)
   - Potential impact
   - Suggested remediation (if any)

3. **Include:**
   - Your contact information
   - Proof-of-concept code (if applicable)
   - Timeline for fixing (suggested 90 days)

### Example Report Template

```
Subject: [SECURITY] Vulnerability in FundMe Contract

Description:
Brief explanation of the vulnerability

Steps to Reproduce:
1. ...
2. ...
3. ...

Impact:
Describe the potential impact

Suggested Fix:
(Optional) Suggest how to fix this issue

Timeline:
Please fix by [date, typically 90 days from now]
```

### What to Expect

- **Acknowledgment**: Within 24-48 hours
- **Assessment**: Within 1 week
- **Status updates**: Every 2 weeks
- **Public disclosure**: After fix is deployed, or 90 days max

## Best Practices for Users

### For Users of the Contract

1. **Verify Contract Address**
   - Only use official verified addresses
   - Check Etherscan for verification
   - Never trust unverified contracts

2. **Start Small**
   - Test with small amounts first
   - Use testnet before mainnet
   - Verify contract behavior

3. **Wallet Security**
   - Use hardware wallets for significant amounts
   - Never share private keys
   - Use strong passwords

4. **Price Checking**
   - Verify USD minimums are reasonable
   - Check current ETH/USD rates
   - Understand price slippage risks

### For Developers

1. **Testing**
   - Run full test suite before deployment
   - Test with various ETH/USD prices
   - Test edge cases and error conditions

2. **Deployment**
   - Deploy to testnet first
   - Verify on Etherscan
   - Use correct network parameters
   - Keep private keys secure

3. **Monitoring**
   - Monitor contract events
   - Watch for unusual activity
   - Keep logs of transactions

4. **Upgrades**
   - Plan for future improvements
   - Document breaking changes
   - Test thoroughly before deployment

## Security Resources

- [Smart Contract Security](https://www.secureum.xyz/)
- [Solidity Security Guide](https://docs.soliditylang.org/en/latest/security-considerations.html)
- [OWASP Smart Contracts](https://owasp.org/www-project-smart-contract-top-10/)
- [Ethereum Development Best Practices](https://ethereum.org/en/developers/docs/smart-contracts/security/)
- [Trail of Bits Security](https://assets.trailofbits.com/research_publications.html)

## Security Update Process

When security issues are discovered:

1. **Fix Development**
   - Create security-fix branch (not public)
   - Implement and test fix
   - Review with team

2. **Pre-Release Notification**
   - Notify affected users if applicable
   - Provide clear upgrade instructions
   - Document the vulnerability and fix

3. **Release**
   - Deploy fix
   - Create public disclosure
   - Update documentation

4. **Post-Release**
   - Monitor for issues
   - Provide support for upgrades
   - Update security knowledge

## Emergency Contacts

For urgent security issues:

- Email: security@fundme.example.com
- GitHub Security Advisory: [Report](https://github.com/security/advisories)

## Security Checklist

Before production deployment:

- [ ] Contract audited by reputable firm
- [ ] All tests pass with 100% coverage
- [ ] Code reviewed by multiple developers
- [ ] No hardcoded test values in production code
- [ ] Correct network addresses configured
- [ ] Price feed validation implemented
- [ ] Emergency pause mechanism added (optional)
- [ ] Multi-sig or timelock for withdrawals considered
- [ ] Gas optimization verified
- [ ] Documentation complete and accurate

## Related Documentation

- [README.md](README.md) - Project overview
- [ONBOARDING.md](ONBOARDING.md) - Getting started
- [CONTRIBUTING.md](CONTRIBUTING.md) - Development guidelines

---

**Security is a shared responsibility. Thank you for helping keep FundMe safe!**

Last Updated: May 2026
