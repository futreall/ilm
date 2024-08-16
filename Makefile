# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

.PHONY: test clean

# Build & test
build                   :; forge build
coverage                :; forge coverage
gas                     :; forge test --gas-report
gas-check               :; forge snapshot --check --tolerance 1
snapshot                :; forge snapshot
clean                   :; forge clean
fmt                     :; forge fmt
run-simulation          :; mkdir -p ./test/integration/output && forge test --mt test_e2eSimulation
test-invariant-rewards  :; forge test --mt invariant_LoopStrategyRewards
test        						:; forge test --no-match-test "test_e2eSimulation|invariant" --gas-report $(VERBOSITY)
test-verbose       			:; make test VERBOSITY="-vvv"

# Deploy
deploy-base-mainnet     :; forge script script/deploy/base-mainnet/${SCRIPT_CONTRACT}.s.sol --tc ${SCRIPT_CONTRACT} --force --rpc-url base --chain base --slow --broadcast --verify --delay 5 -vvvv
deploy-tenderly					:; forge script script/deploy/base-mainnet/${SCRIPT_CONTRACT}.s.sol --tc ${SCRIPT_CONTRACT} --force --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}

