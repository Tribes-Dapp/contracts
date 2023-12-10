// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Helper} from "@script/utils/Helper.sol";
import {Tribe} from "@contracts/token/ERC1155/Tribe.sol";

contract DeployTribe is Script {
    Helper helper = new Helper();

    function run() external {
        (address _dapp, address _inputBox,) = helper.data();

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Tribe tribe = new Tribe(_dapp, _inputBox);
        vm.stopBroadcast();
        
        console.log("Tribe address:", address(tribe));
    }
}
