// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address contractAddress = DevOpsTools.get_most_recent_deployment("ERC1976Proxy", block.chainid);
        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        address proxy = upgradeBox(contractAddress, address(newBox));
        vm.stopBroadcast();
        return proxy;
    }

    function upgradeBox(address proxy, address newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1 boxV1 = BoxV1(proxy);
        boxV1.upgradeToAndCall(newBox, ""); //proxy points to this new address
        vm.stopBroadcast();
        return address(boxV1);
    }
}
