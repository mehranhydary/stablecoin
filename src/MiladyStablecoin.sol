// SPDX-License-Identifier: GPL-3.0

// Layout of contract
// Version, imports, errors, interfaces, libraries, contracts, type declarations,
// state variables, events, modifiers, functions

// Layout of functions
// constructor, receive, fallback, external, public, internal,
// privaate, view, pure functions

pragma solidity >=0.5.0 <0.9.0;

import {ERC20} from "solady/src/tokens/ERC20.sol";
import {Ownable} from "solady/src/auth/Ownable.sol";

/**
 * @title Milady Stable Coin
 * @author 𝖒
 * Collateral: Milady NFTx Vault
 * Minting: Algorithmic
 * Relative Stability: Pegged to USD
 *
 * This is the contract governed by MiladySCEngine. This contract is just the
 * ERC20 implementation of the stablecoin system.
 */
contract MiladyStableCoin is ERC20, Ownable {
    error MiladyStableCoin__MustBeMoreThanZero();
    error MiladyStableCoin__BurnAmountExceedsBalance();
    error MiladyStableCoin__NotZeroAddress();

    string public constant NAME = "Milady Stable Coin";
    string public constant SYMBOL = "MSC";
    uint8 public constant DECIMALS = 18;

    function name() public pure override returns (string memory) {
        return NAME;
    }

    function symbol() public pure override returns (string memory) {
        return SYMBOL;
    }

    function decimals() public pure override returns (uint8) {
        return DECIMALS;
    }

    function burn(uint256 _amount) external onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount == 0) {
            revert MiladyStableCoin__MustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert MiladyStableCoin__BurnAmountExceedsBalance();
        }
        _burn(msg.sender, _amount);
    }

    function mint(
        address _to,
        uint256 _amount
    ) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert MiladyStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert MiladyStableCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
