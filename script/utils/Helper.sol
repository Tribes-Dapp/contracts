// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

struct Data {
    address dapp;
    address inputBox;
    bytes32 salt;
}

contract Helper {
    Data public data;

    constructor() {
        data = _strategyArgs();
    }

    function _getTestnetArgs() internal pure returns (Data memory args) {
        args = Data({
            dapp: address(0), // change this to your dapp address
            inputBox: 0x59b22D57D4f067708AB0c00552767405926dc768,
            salt: bytes32(abi.encode(6)) // change every time you deploy
        });
    }

    function _getLocalArgs() internal pure returns (Data memory args) {
        args = Data({
            dapp: 0x70ac08179605AF2D9e75782b8DEcDD3c22aA4D0C,
            inputBox: address(1),
            salt: bytes32(abi.encode(0))
        });
    }

    function _strategyArgs() internal view returns (Data memory args) {
        if (block.chainid == 31337) {
            return _getLocalArgs();
        } else {
            return _getTestnetArgs();
        }
    }
}
