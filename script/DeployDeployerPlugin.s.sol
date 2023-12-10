// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Helper} from "@script/utils/Helper.sol";
import {DeployerPlugin} from "@contracts/proxy/DeployerPlugin.sol";

contract DeployDeployerPlugin is Script {
    Helper helper = new Helper();

    function run() external {
        (, address _inputBox, bytes32 _salt) = helper.data();

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        DeployerPlugin proxy = (new DeployerPlugin){salt: _salt}(_inputBox);
        vm.stopBroadcast();

        console.log("Proxy deployer plugin address:", address(proxy)); 
    }
}
