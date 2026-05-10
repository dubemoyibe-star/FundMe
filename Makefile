-include .env 

.PHONY: all clean build test test-fork deploy-sepolia 
ANVIL_PRIVATE_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all: install build test

install:
	@echo "Installing dependencies..."
	forge install smartcontractkit/chainlink-evm@contracts-v1.5.0 
	forge install Cyfrin/foundry-devops 
	forge install foundry-rs/forge-std 

clean:
	@echo "Cleaning the project..."
	forge clean

build:
	@echo "Building the project..."
	forge build

test:
	@echo "Running tests..."
	forge test -vvv

update:
	@echo "Updating dependencies..."
	forge update

snapshot:
	@echo "Creating a snapshot of the current blockchain state..."
	forge snapshot

anvil:
	@echo "Starting Anvil local blockchain..."
	anvil

format:
	@echo "Formatting the code..."
	forge fmt

fund:
	@echo "Funding the contract with 0.01 ETH..."
	forge script script/Interactions.s.sol:FundFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account myWallet \
		--broadcast \
		-vvvv

withdraw:
	@echo "Withdrawing funds from the contract..."
	forge script script/Interactions.s.sol:WithdrawFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account myWallet \
		--broadcast \
		-vvvv

test-fork:
	@echo "Running tests with fork..."
	forge test --fork-url $(SEPOLIA_RPC_URL) -vvv

deploy-local:
	@echo "Deploying to local Anvil blockchain..."
	forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url http://127.0.0.1:8545 \
		--private-key $(ANVIL_PRIVATE_KEY) \
		--broadcast \
		-vvvv

deploy-sepolia:
	@echo "Deploying to Sepolia testnet..."
	forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account myWallet \
		--broadcast \
		--verify \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		-vvvv

		