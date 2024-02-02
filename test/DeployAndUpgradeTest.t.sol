// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox deployBox;
    UpgradeBox upgradeBox;
    address public Owner = makeAddr("owner");
    address proxy;

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();
        proxy = deployBox.run(); //right noe points to v1
    }

    function testUpgrades() public {
        BoxV2 boxv2 = new BoxV2();
        upgradeBox.upgradeBox(proxy, address(boxv2));
        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());
    }
}
