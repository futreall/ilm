// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.21;

import { Script } from "forge-std/Script.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { DeployHelper } from "../DeployHelper.s.sol";
import { WrappedERC20PermissionedDeposit } from
    "../../../src/tokens/WrappedERC20PermissionedDeposit.sol";
import { ERC20Config } from "../config/LoopStrategyConfig.sol";

contract WrappedUSDCConfig {
    ERC20Config public wrappedUSDCConfig =
        ERC20Config({ name: "Seamless ILM Reserved USDC", symbol: "rUSDC" });
}

/// @title DeployWrappedUSDC
/// @notice deploys and setup Seamless wrapped USDC token
/// @notice gives admin roles to the SEAMLESS_GOV_SHORT_TIMELOCK_ADDRESS and SEAMLESS_COMMUNITY_MULTISIG
contract DeployWrappedUSDC is Script, DeployHelper, WrappedUSDCConfig {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PK");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        WrappedERC20PermissionedDeposit wrappedToken = _deployWrappedToken(
            deployerAddress, wrappedUSDCConfig, IERC20(BASE_MAINNET_USDC)
        );

        wrappedToken.grantRole(
            wrappedToken.DEFAULT_ADMIN_ROLE(),
            SEAMLESS_GOV_SHORT_TIMELOCK_ADDRESS
        );
        wrappedToken.grantRole(
            wrappedToken.DEFAULT_ADMIN_ROLE(), SEAMLESS_COMMUNITY_MULTISIG
        );

        wrappedToken.renounceRole(
            wrappedToken.DEFAULT_ADMIN_ROLE(), deployerAddress
        );

        vm.stopBroadcast();
    }
}
