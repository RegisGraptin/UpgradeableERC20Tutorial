// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {MyERC20} from "../src/MyERC20.sol";

contract DeployMyERC20Script is Script {
    MyERC20 public erc20;

    function setUp() public {}

    function run() public returns (address, address) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        address proxy = Upgrades.deployUUPSProxy("MyERC20.sol", abi.encodeCall(MyERC20.initialize, ()));

        // Get the implementation address
        address implementationAddress = Upgrades.getImplementationAddress(proxy);

        vm.stopBroadcast();

        console.log("Implementation Address:", implementationAddress);
        console.log("Proxy Address:", proxy);

        return (implementationAddress, proxy);
    }
}
