# Integrated Liquidity Market (ILM)

The ILMs are a set of contracts which increase capital efficiency chiefly by reducing friction of capital deployment and costs of position management. The `ILM` repo hosts all contracts, tests and deployment scripts necessary for build, test, deploy and configure the `ILM` strategies.

## Architecture

The ILMs are accessible to users by interaction with the `Strategy` contracts. The functioning of these strategies is supported by the `Swapper` contract suite, which serves the purpose of managing integrations, thus swaps, with several DEXs.

The `Strategy` contracts leverage several external libraries for borrowing/repaying loans with the `Seamless` lending pools, conversions and rebalancing.

The `Swapper` contract is essentially a routing contract, and simply routes swaps through `SwapAdapter` contracts, which handle the DEX-specific swapping logic.

All contracts follow the unstructured storage pattern, where a hash is used to define the storage slot for the part of the state of the contract.

## Documentation

The first of these contracts is the [Looping Strategy](./SPECS.md), which swaps borrowed funds to for collateral funds to achieve a higher exposure to the collateral token.

A [summary](/docs/src/SUMMARY.md) of the `Looping Strategy` interfaces and contracts is provided in the repo as well.

The ILM repo is subject to the [Styling Guide](./STYLING_GUIDE.md).

The ILMs integrate directly with the [Seamless Protocol](https://docs.seamlessprotocol.com) which fulfills the role of the lender.

## Deployment Addresses

### Base Mainnet

| Contract                     | Proxy address                                | Implementation address                       |
| ---------------------------- | -------------------------------------------- | -------------------------------------------- |
| wstETH/ETH 3x Loop Strategy  | `0x258730e23cF2f25887Cb962d32Bd10b878ea8a4e` | `0xceFEB99ADdeb0F408237379Eb355CF96bA6fD328` |
| WETH/USDC 1.5x Loop Strategy | `0x2FB1bEa0a63F77eFa77619B903B2830b52eE78f4` | `0xceFEB99ADdeb0F408237379Eb355CF96bA6fD328` |
| WETH/USDC 3x Loop Strategy   | `0x5Ed6167232b937B0A5C84b49031139F405C09c8A` | `0x588313d69F6cA189029D83A3012fd3C40be4Eac5` |
| Seamless ILM Reserved wstETH |                                              | `0xc9ae3B5673341859D3aC55941D27C8Be4698C9e4` |
| Seamless ILM Reserved WETH   |                                              | `0x3e8707557D4aD25d6042f590bCF8A06071Da2c5F` |
| Swapper                      | `0xE314ae9D279919a00d4773cCe37946A98fADDaBc` | `0x08561d280654790861591fFAf68ed193AdDC479D` |
| WrappedTokenAdapter          |                                              | `0x1508F1B71210593406f8b614dcc41cdF3e6d2a6d` |
| AerodromeAdapter             |                                              | `0x6Cfc78c96f87e522EBfDF86995609414cFB1DcB2` |
| UniversalAerodromeAdapter    |                                              | `0x87f8D14A8796b22116d267CFE9A57e986F207468` |
| ILMRegistry                  |                                              | `0x36291d2D51a0122B9faCbE3c3F989cc6b1f859B3` |

## Audits

TBA

## Usage

### Installation

```markdown
forge install
```

### Build

```markdown
make build
```

### Test

```markdown
make test
```

### Deployment

```markdown
make deploy-wrappedwstETH-fork

# update the address of the wrappedToken in the LoopStrategyWstETHoverETHConfig

make deploy-loopStrategyWstETHoverETH-fork
```
