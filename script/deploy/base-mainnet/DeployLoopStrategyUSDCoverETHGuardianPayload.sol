// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.21;

import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { IAccessControl } from
    "@openzeppelin/contracts/access/IAccessControl.sol";
import { ISwapper } from "../../../src/swap/Swapper.sol";
import { ILoopStrategy } from "../../../src/LoopStrategy.sol";
import { IWrappedTokenAdapter } from
    "../../../src/interfaces/IWrappedTokenAdapter.sol";
import { IAerodromeAdapter } from
    "../../../src/interfaces/IAerodromeAdapter.sol";
import { IWrappedERC20PermissionedDeposit } from
    "../../../src/tokens/WrappedERC20PermissionedDeposit.sol";
import { StrategyAssets } from "../../../src/types/DataTypes.sol";
import { ISwapAdapter } from "../../../src/interfaces/ISwapAdapter.sol";
import { DeployHelperLib } from "../DeployHelperLib.sol";
import { BaseMainnetConstants } from "../config/BaseMainnetConstants.sol";

interface IOwnable2Step {
    function transferOwnership(address newOwner) external;
    function acceptOwnership() external;
}

/// @notice Helper setup contract which guardian or governance can call to setup this USDC/ETH strategy
contract DeployLoopStrategyUSDCoverETHGuardianPayload is
    BaseMainnetConstants
{
    error NotAuthorized();

    function run(ILoopStrategy strategy) external {
        if (
            msg.sender != SEAMLESS_COMMUNITY_MULTISIG
                && msg.sender != SEAMLESS_GOV_SHORT_TIMELOCK_ADDRESS
        ) {
            revert NotAuthorized();
        }

        StrategyAssets memory strategyAssets = strategy.getAssets();

        IWrappedERC20PermissionedDeposit wrappedToken =
            IWrappedERC20PermissionedDeposit(address(strategyAssets.collateral));
        IWrappedTokenAdapter wrappedTokenAdapter =
            IWrappedTokenAdapter(WRAPPED_TOKEN_ADAPTER);

        IAccessControl(address(wrappedToken)).grantRole(
            wrappedToken.DEPOSITOR_ROLE(), address(strategy)
        );
        IAccessControl(address(wrappedToken)).grantRole(
            wrappedToken.DEPOSITOR_ROLE(), WRAPPED_TOKEN_ADAPTER
        );

        wrappedTokenAdapter.setWrapper(
            wrappedToken.underlying(),
            IERC20(address(wrappedToken)),
            wrappedToken
        );

        DeployHelperLib._setSwapperRouteBetweenWrappedAndToken(
            ISwapper(SWAPPER),
            wrappedToken,
            strategyAssets.debt,
            ISwapAdapter(address(wrappedTokenAdapter)),
            ISwapAdapter(UNIVERSAL_AERODROME_ADAPTER),
            40000 // 0.04 % - value is set to 40000 / 100000000 which is pool fee at time of deployment
        );

        bytes32 STRATEGY_ROLE = keccak256("STRATEGY_ROLE");
        IAccessControl(SWAPPER).grantRole(STRATEGY_ROLE, address(strategy));

        _renounceDefaultAdmin(address(wrappedToken));
        _renounceDefaultAdmin(SWAPPER);
        _renounceManager(address(wrappedTokenAdapter));
        _renounceManager(SWAPPER);
    }

    function _renounceDefaultAdmin(address contractAddress) internal {
        bytes32 DEFAULT_ADMIN_ROLE = 0x00;
        IAccessControl(contractAddress).renounceRole(
            DEFAULT_ADMIN_ROLE, address(this)
        );
    }

    function _renounceManager(address contractAddress) internal {
        bytes32 MANAGER_ROLE = keccak256("MANAGER_ROLE");
        IAccessControl(contractAddress).renounceRole(
            MANAGER_ROLE, address(this)
        );
    }
}
