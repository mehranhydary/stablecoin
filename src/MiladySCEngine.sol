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
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// import {IUniswapV2Pair} from "v2-core/contracts/interfaces/IUniswapV2Pair.sol";
// import {FixedPoint} from "v2-periphery/contracts/libraries/FixedPoint.sol";
// import {UniswapV2OracleLibrary} from "v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol";
// import {UniswapV2Library} from "v2-periphery/contracts/libraries/UniswapV2Library.sol";

contract MiladySCEngine is ReentrancyGuard {
    error MiladySCEngine__NeedsMoreThanZero();
    error MiladySCEngine__NotZeroAddress();
    error MiladySCEngine__NotAllowedToken();
    error MiladySCEngine__TransferFailed();

    // Note: Keeping this a mapping for now because in case we want to do multi-collateral
    mapping(address token => bool) private s_allowedTokens; // token address to boolean
    mapping(address user => mapping(address token => uint256 amount))
        private s_collateralDeposited; // Map user to mapping of token address to amount
    mapping(address user => uint256 amountMscMinted) private s_MSCMinted;

    MiladyStableCoin private immutable i_msc; // i for immutable

    event CollateralDeposited(
        address indexed user,
        address indexed token,
        uint256 indexed amount
    );

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
     * @notice follows CEI pattern (checks, effects, internal interactions)
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
    {
        // Check how much collateral someone has deposited
        s_collateralDeposited[msg.sender][
            tokenCollateralAddress
        ] += amountCollateral;

        emit CollateralDeposited(
            msg.sender,
            tokenCollateralAddress,
            amountCollateral
        );

        bool success = IERC20(tokenCollateralAddress).transferFrom(
            msg.sender,
            address(this),
            amountCollateral
        );

        if (!success) {
            revert MiladySCEngine__TransferFailed();
        }
    }

    function redeemCollateralForMsc() external {}

    function redeemCollateral() external {}

    /**
     * @notice follows CEI pattern
     * @param amountMscToMint The amount of MSC to mint
     * @notice They must have more collateral value than the minimum threshold
     */
    function mintMsc(
        uint256 amountMscToMint
    ) external moreThanZero(amountMscToMint) nonReentrant {
        s_MSCMinted[msg.sender] += amountMscToMint;
        // Check if they minted too much MSC
        _revertIfHealthFactorIsBroken(msg.sender);
    }

    function burnMsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    function _getAccountInformation(
        address user
    )
        private
        view
        returns (uint256 totalMscMinted, uint256 collateralValueInUsd)
    {
        totalMscMinted = s_MSCMinted[user];
        // Need to do some math
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    /**
     * @notice Returns how close to liquidation a user is
     * If a user goes below 1, then they can get liquidated
     */
    function _healthFactor(address user) private view returns (uint256) {
        // Get the total MSC minted
        // Get the total collateral value (value is greater than total MSC minted)
        (
            uint256 totalMscMinted,
            uint256 collateralValueInUsd
        ) = _getAccountInformation(user);
    }

    function _revertIfHealthFactorIsBroken(address user) internal view {
        // Check health factor (do they have enough collateral)
        // Revert if they don't have good health factor ()
    }

    function getAccountCollateralValue(
        address user
    ) public view returns (uint256) {
        // Look through each collateral token, get amount they have deposited
        // and map it to the price to get the USD value
    }

    function getUsdValue(
        address token,
        uint256 amount
    ) public view returns (uint256) {
        // Get current price of NFTx Milady token
    }
}
