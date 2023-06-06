// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

import "forge-std/Test.sol";
import "../src/MiladySCEngine.sol";
import "../src/MiladyStableCoin.sol";

contract MiladySCTest is Test {
    MiladyStableCoin private _msc;
    MiladySCEngine private _mscEngine;

    function setUp() public {
        _msc = new MiladyStableCoin();
        _mscEngine = new MiladySCEngine(
            0x227c7DF69D3ed1ae7574A1a7685fDEd90292EB48, // Milady NFTx Token
            address(_msc)
        );
    }
}
