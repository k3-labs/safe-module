// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract ERC20Script is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        ERC20Mock erc20 = new ERC20Mock();
        erc20.mint(0xF6BfD287CAB17C930b7163008ed4ad13E7067f80, 100000 ether);
        vm.stopBroadcast();
    }
}
