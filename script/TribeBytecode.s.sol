// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Tribe} from "@contracts/token/ERC1155/Tribe.sol";

contract TribesBytecode is Script {
    address dapp = address(0); //change this to your dapp address

    function run() external view {
        console.log("Tribe bytecode:");
        console.logBytes(abi.encodePacked(type(Tribe).creationCode, abi.encode(dapp))
        );
    }
}
