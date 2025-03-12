// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {K3Module, Enum} from "../src/k3-module.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract K3ModuleTest is Test {
    uint256 baseSepoliaFork;
    K3Module module = K3Module(0x7845383068Fa1C8af57fb8BA34DEF37144E904B7);

    address safe = 0xF6BfD287CAB17C930b7163008ed4ad13E7067f80;
    ERC20Mock erc20;

    address owner = 0x16d2256aBf9e8E7e468E87457d824F2Af408d78D;

    function setUp() public {
        baseSepoliaFork = vm.createFork('baseSepolia');
        vm.selectFork(baseSepoliaFork);
        erc20 = new ERC20Mock();
        erc20.mint(safe, 100 ether);
    }

    function test() public {
       assertEq(erc20.balanceOf(safe), 100 ether);

       address to = address(0x1);
       uint256 amount = 10 ether;

       bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", to, amount);
       console.logBytes(data);
       vm.prank(owner);
       module.execute(address(erc20), 0, data, Enum.Operation.Call);
       assertEq(erc20.balanceOf(address(0x1)), 10 ether);


    }

}
