// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ZKPVerifier} from "@iden3/ZKPVerifier.sol";
import {GenesisUtils} from "@iden3/lib/GenesisUtils.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {ICircuitValidator} from "@iden3/interfaces/ICircuitValidator.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract Tribe is ZKPVerifier, ERC1155, AccessControl, ERC1155Burnable {
    address public dapp;
    address public inputBox;

    uint64 public constant KYC_REQUEST_ID = 1;

    bytes32 public constant DAPP_ROLE = keccak256("DAPP_ROLE");

    error UserNotWhitelisted(address sender, uint64 requestId);
    error VerificationFailed(address sender, uint64 requestId);

    event Whitelisted(address sender, uint64 requestId);
    event VerificationCompleted(address sender, uint64 requestId);

    constructor(address _dapp) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, _dapp);
        _grantRole(DAPP_ROLE, _dapp);
        dapp = _dapp;
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyRole(DAPP_ROLE) {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyRole(DAPP_ROLE) {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeProofSubmit(
        uint64 requestId,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal override {
        address addr = GenesisUtils.int256ToAddress(
            inputs[validator.getChallengeInputIndex()]
        );
        if (_msgSender() != addr)
            revert VerificationFailed(_msgSender(), requestId);
        emit VerificationCompleted(_msgSender(), requestId);
    }

    function _afterProofSubmit(
        uint64 requestId,
        uint256[] memory /* inputs */,
        ICircuitValidator /* validator */
    ) internal override {
        IInputBox(inputBox).addInput(
            dapp,
            abi.encodePacked(msg.sig, _msgSender())
        );
        emit Whitelisted(_msgSender(), requestId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        if (proofs[to][KYC_REQUEST_ID] != true)
            revert UserNotWhitelisted(to, KYC_REQUEST_ID);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
