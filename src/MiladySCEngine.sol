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

contract MiladySCEngine {
    error MiladySCEngine__NeedsMoreThanZero();

    mapping(address token => address priceFeed) private s_priceFeeds; // tokenToPriceFeed

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert MiladySCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address tokenAddress) {
        revert _;
    }

    constructor(address[] memory allowedTokens, address mscAddress) {}

    function depositCollateralAndMintMsc() external {}

    /**
     * @param tokenCollateralAddress The address of the ERC20 token to deposit as collateral
     * @param amountCollateral The amount of the ERC20 token to deposit as collateral
     */
    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
    ) external moreThanZero(amountCollateral) {}

    function redeemCollateralForMsc() external {}

    function redeemCollateral() external {}

    function mintMsc() external {}

    function burnMsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
