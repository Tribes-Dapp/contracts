//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Helper} from "@script/utils/Helper.sol";
import {Tribe} from "@contracts/token/ERC1155/Tribe.sol";
import {DeployerPlugin} from "@contracts/proxy/DeployerPlugin.sol";

contract TestDeployerPlugin is Test {
    address tribe;
    bytes bytecode;
    DeployerPlugin proxy;
    address dapp = address(3);
    address costumer = address(1);
    address inputBox = address(2);

    function setUp() public {
        proxy = (new DeployerPlugin){salt: bytes32(abi.encode(1))}(address(4));
        vm.prank(dapp);
        bytecode = abi.encodePacked(type(Tribe).creationCode, abi.encode(dapp));
        tribe = proxy.deploy("79f89805-ac94-49ea-b589-b1807c6265da", bytecode);
    }

    function testDappRole() public {
        string memory id = "79f89805-ac94-49ea-b589-b1807c6265da";
        bytecode = abi.encodePacked(type(Tribe).creationCode, abi.encode(dapp));
        vm.prank(dapp);
        tribe = proxy.deploy(id, bytecode);
        bytes32 result = Tribe(tribe).DAPP_ROLE();
        bool hasRole = Tribe(tribe).hasRole(result, dapp);
        assertTrue(hasRole);
    }

    function testMint() public {
        vm.prank(dapp);
        Tribe(tribe).mint(costumer, 1, 1);
        uint256 balance = Tribe(tribe).balanceOf(costumer, 1);
        assertEq(balance, 1);
    }

    function testPause() public {
        vm.prank(dapp);
        Tribe(tribe).pause();
        vm.expectRevert();
        Tribe(tribe).mint(costumer, 1, 1);
    }

    function testUnpause() public {
        vm.prank(dapp);
        Tribe(tribe).pause();
        vm.prank(dapp);
        Tribe(tribe).unpause();
        vm.prank(dapp);
        Tribe(tribe).mint(costumer, 1, 1);
        uint256 balance = Tribe(tribe).balanceOf(costumer, 1);
        assertEq(balance, 1);
    }
}
