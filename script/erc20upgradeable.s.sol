// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {UnsafeUpgrades} from "lib/openzeppelin-foundry-upgrades/src/Upgrades.sol";
import {ERC20MockUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/mocks/token/ERC20MockUpgradeable.sol";

contract ERC20UpgradeScript is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        ERC20MockUpgradeable erc20Imp = new ERC20MockUpgradeable();
        address proxy = UnsafeUpgrades.deployTransparentProxy(address(erc20Imp), 0xDa327b857d678825743a45767b03F0c2E052Ed8e, "");
        ERC20MockUpgradeable erc20 = ERC20MockUpgradeable(proxy);
        erc20.mint(0xF6BfD287CAB17C930b7163008ed4ad13E7067f80, 100000000000 ether);
        vm.stopBroadcast();
    }
}
