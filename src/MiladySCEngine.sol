// SPDX-License-Identifier: GPL-3.0

// Layout of contract
// Version, imports, errors, interfaces, libraries, contracts, type declarations,
// state variables, events, modifiers, functions

// Layout of functions
// constructor, receive, fallback, external, public, internal,
// privaate, view, pure functions

/**
 * @title MiladySCEngine
 * @author 𝖒
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a
 * token == $1 peg.
 * The stablecoin has properties:
 * - Collateral will be Milady NFTx Vault
 * - Dollar pegged
 * - Algorithmically stable
 *
 * It is similar to DAI if DAI had no governance, no fees.
 *
 * Our MSC system should always be "overcollateralized". At no point, should the value of all
 * all collateral <= the $ backed value of all the MSC.
 *
 * @notice This contract is the core of the MiladySC System. It handles all the logic for mining
 * and redemption MiladySC, as well as depositing and withdrawing collateral.
 * @notice This contract is very loosely based on the MakerDAO DSS (DAI).
 */

pragma solidity ^0.8.18;

// Will need this to get the price of an NFTx Milady Vault
import {MiladyStableCoin} from "./MiladyStableCoin.sol";
import {IUniswapV2Pair} from "v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {FixedPoint} from "v2-periphery/contracts/libraries/FixedPoint.sol";
import {UniswapV2OracleLibrary} from "v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol";
import {UniswapV2Library} from "v2-periphery/contracts/libraries/UniswapV2Library.sol";

contract MiladySCEngine {
    error MiladySCEngine__NeedsMoreThanZero();
    error MiladySCEngine__NotZeroAddress();
    error MiladySCEngine__NotAllowedToken();

    // Note: Keeping this a mapping for now because in case we want to do multi-collateral
    mapping(address token => bool) private s_allowedTokens; // token address to boolean
    MiladyStableCoin private immutable i_msc; // i for immutable

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert MiladySCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address tokenAddress) {
        if (s_allowedTokens[tokenAddress] == false) {
            revert MiladySCEngine__NotAllowedToken();
        }
        _;
    }

    // Don't think you need this right now
    constructor(address miladyAddress, address mscAddress) {
        if (miladyAddress == address(0)) {
            revert MiladySCEngine__NotZeroAddress();
        }
        if (mscAddress == address(0)) {
            revert MiladySCEngine__NotZeroAddress();
        }
        s_allowedTokens[miladyAddress] = true;
        i_msc = MiladyStableCoin(mscAddress);
    }

    function depositCollateralAndMintMsc() external {}

    /**
     * @param tokenCollateralAddress The address of the ERC20 token to deposit as collateral
     * @param amountCollateral The amount of the ERC20 token to deposit as collateral
     */
    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
    )
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {}

    function redeemCollateralForMsc() external {}

    function redeemCollateral() external {}

    function mintMsc() external {}

    function burnMsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
