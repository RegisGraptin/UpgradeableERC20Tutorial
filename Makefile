include .env

build:
   forge clean && forge build

test: build
   forge test

simulate-deploy: build
   forge script script/DeployMyERC20.s.sol:DeployMyERC20Script \
      --fork-url sepolia

deploy: build
   forge script script/DeployMyERC20.s.sol:DeployMyERC20Script \
      --rpc-url sepolia \
      --broadcast \
      --verify

simulate-upgrade: build
   forge script script/UpgradeMyERC20.s.sol:UpgradeMyERC20Script \
      --fork-url sepolia

upgrade: build
   forge script script/UpgradeMyERC20.s.sol:UpgradeMyERC20Script \
      --rpc-url sepolia \
      --broadcast \
      --verify