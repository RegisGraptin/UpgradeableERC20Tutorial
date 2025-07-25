// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MyERC20 is Initializable, UUPSUpgradeable, OwnableUpgradeable, ERC20Upgradeable {

    uint256 public counter;
    uint256[49] __gap;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __Ownable_init(msg.sender);
        __ERC20_init("UpgradableSmartContract", "USC");
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function increase() public {
        _mint(msg.sender, 1);
        counter++;
    }
}