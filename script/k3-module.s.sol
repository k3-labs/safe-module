// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {K3Module} from '../src/k3-module.sol';

contract K3ModuleScript is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address owner = 0x3c7a1a9c769009D21fe2FCfb08c7334919F641fe;
        address safe = 0xF6BfD287CAB17C930b7163008ed4ad13E7067f80;

        K3Module module = new K3Module(safe);
        // K3Module module = new K3Module(owner, safe);

        console.log("Module created at address: ", address(module));
        vm.stopBroadcast();
    }
}
