# LOADING ENV FILE
-include .env

.PHONY: plugin tribe bytecode

# DEFAULT VARIABLES
START_LOG = @echo "==================== START OF LOG ===================="
END_LOG = @echo "==================== END OF LOG ======================"

define deploy_deployer_plugin
	$(START_LOG)
	@forge test
	@forge script script/DeployDeployerPlugin.s.sol --rpc-url $(RPC_URL) --broadcast -vvvvv
	$(END_LOG)
endef

define deploy_tribe
	$(START_LOG)
	@forge test
	@forge script script/DeployTribe.s.sol --rpc-url $(RPC_URL) --broadcast --verify -vvvvv
	$(END_LOG)
endef

define tribe_bytecode
	$(START_LOG)
	@forge script script/TribeBytecode.s.sol
	$(END_LOG)
endef

env: .env.tmpl
	cp .env.tmpl .env

plugin:
	@echo "Deploying plugin..."
	@$(deploy_deployer_plugin)

tribe:
	@echo "Deploying tribe..."
	@$(deploy_tribe)

bytecode:
	@echo "Getting tribe bytecode..."
	@$(tribe_bytecode)