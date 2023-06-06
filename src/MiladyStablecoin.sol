// SPDX-License-Identifier: GPL-3.0

// Layout of contract
// Version, imports, errors, interfaces, libraries, contracts, type declarations,
// state variables, events, modifiers, functions

// Layout of functions
// constructor, receive, fallback, external, public, internal,
// privaate, view, pure functions

pragma solidity ^0.8.18;

import {ERC20} from "solady/src/tokens/ERC20.sol";

/**
 * @title Stablecoin
 * @author 𝖒
 * Collateral: Milady NFTx Vault
 * Minting: Algorithmic
 * Relative Stability: Pegged to USD
 *
 * This is the contract governed by MiladySCEngine. This contract is just the
 * ERC20 implementation of the stablecoin system.
 */
contract MiladyStablecoin is ERC20 {
    // Name
    string public constant NAME = "Milady Stablecoin";
    // Symbol
    string public constant SYMBOL = "MILADY";
    // Decimals
    uint8 public constant DECIMALS = 18;

    constructor() {}

    function name() public pure override returns (string memory) {
        return NAME;
    }

    function symbol() public pure override returns (string memory) {
        return SYMBOL;
    }

    function decimals() public pure override returns (uint8) {
        return DECIMALS;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
