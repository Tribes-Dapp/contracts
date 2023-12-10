// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Helper} from "@script/utils/Helper.sol";
import {Tribe} from "@contracts/token/ERC1155/Tribe.sol";

contract TribesBytecode is Script {
    Helper helper = new Helper();

    function run() external view {
        (address _dapp, address _inputBox,) = helper.data();

        bytes memory bytecode = type(Tribe).creationCode;

        console.log("Tribe bytecode:");
        console.logBytes(
            abi.encodePacked(bytecode, abi.encodePacked(bytecode, abi.encode(_dapp, _inputBox)))
        );
    }
}
