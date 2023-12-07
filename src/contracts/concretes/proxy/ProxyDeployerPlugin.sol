// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";

contract ProxyDeployerPlugin {
    address public inputBox;

    constructor(address _inputBox) {
        inputBox = _inputBox;
    }

    event DeployContract(address sender, string id, bytes bytecode);

    error DeployFailed(address sender, string id, bytes bytecode);

    receive() external payable {}

    function deploy(
        address _dapp,
        string memory _id,
        bytes memory _bytecode
    ) external payable returns (address addr) {
        assembly {
            // create(v, p, n)
            // v = amount of ETH to send
            // p = pointer in memory to start of _bytecode
            // n = size of _bytecode
            addr := create(callvalue(), add(_bytecode, 0x20), mload(_bytecode))
        }
        if (addr == address(0)) revert DeployFailed(msg.sender, _id, _bytecode);

        IInputBox(inputBox).addInput(_dapp, abi.encodePacked(_id, addr));
        emit DeployContract(msg.sender, _id, _bytecode);
    }
}
