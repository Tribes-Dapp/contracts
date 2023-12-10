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
        data = _getArgs();
    }

    function _getArgs()
        internal
        pure
        returns (Data memory args)
    {
        args = Data({
            dapp: address(0),
            inputBox: 0x59b22D57D4f067708AB0c00552767405926dc768,
            salt: bytes32(abi.encode(2))
        });
    }
}