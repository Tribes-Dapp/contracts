//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Helper} from "@script/utils/Helper.sol";
import {Tribe} from "@contracts/token/ERC1155/Tribe.sol";
import {DeployerPlugin} from "@contracts/proxy/DeployerPlugin.sol";

contract TestDeployerPlugin is Test {
    bytes bytecode;
    DeployerPlugin proxy;
    address dapp = address(3);
    address inputBox = address(2);

    function setUp() public {
        proxy = (new DeployerPlugin){salt: bytes32(abi.encode(1))}(address(4));
    }

    function testDeploy() public {
        string memory id = "79f89805-ac94-49ea-b589-b1807c6265da";
        bytecode = abi.encodePacked(type(Tribe).creationCode, abi.encode(dapp));
        vm.prank(dapp);
        address tribe = proxy.deploy(id, bytecode);
        bytes32 result = Tribe(tribe).DAPP_ROLE();
        assertEq(result, keccak256("DAPP_ROLE"));
    }
}
