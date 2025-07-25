// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {Test, console} from "forge-std/Test.sol";

import {MyERC20} from "../src/MyERC20.sol";
import {MyERC20v2} from "../src/MyERC20v2.sol";

contract MyERC20Test is Test {
    address proxyAddress;
    address owner = makeAddr("owner");
    address user = makeAddr("user");

    function setUp() public {
        // Deploy our MyERC20 v1
        vm.prank(owner);
        proxyAddress = Upgrades.deployTransparentProxy(
            "MyERC20.sol",
            owner,
            abi.encodeCall(MyERC20.initialize, ())
        );
    }

    function testDeployment() public view {
        MyERC20 proxy = MyERC20(proxyAddress);
        assertEq(proxy.name(), "UpgradableSmartContract");
        assertEq(proxy.symbol(), "USC");
    }

    function testIncrement() public {
        MyERC20 proxy = MyERC20(proxyAddress);

        vm.prank(user);
        proxy.increase();

        assertEq(
            proxy.counter(),
            1,
            "Counter does not have the expected value"
        );
    }

    function testUpgradeContract() public {
        MyERC20 proxy = MyERC20(proxyAddress);
        proxy.increase(); // Increase by 1
        assertEq(proxy.counter(), 1);

        // Upgrade our smart contract
        vm.startPrank(owner);
        Upgrades.upgradeProxy(proxyAddress, "MyERC20v2.sol", "");
        vm.stopPrank();

        // Verify the state of our v2
        MyERC20v2 proxyV2 = MyERC20v2(proxyAddress);
        uint256 beforeCounterValue = proxyV2.counter();
        assertEq(beforeCounterValue, 1); // Still the same amount

        // Call our new 'increase' function
        vm.prank(user);
        proxyV2.increase(); // Increase by 2
        assertEq(
            proxyV2.counter(),
            beforeCounterValue + 2,
            "Counter does not have the expected value"
        );
        assertEq(proxyV2.lastUser(), user, "Last user does not match");
    }
}