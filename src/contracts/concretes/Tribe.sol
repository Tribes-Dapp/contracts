// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ZKPVerifier} from "@iden3/contracts/ZKPVerifier.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {ERC1155Pausable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract Tribes is
    ZKPVerifier,
    ERC1155,
    ERC1155Pausable,
    AccessControl,
    ERC1155Burnable,
    ERC1155Supply
{
    address public inputBox;

    bytes32 public constant DAPP_ROLE = keccak256("DAPP_ROLE");

    uint64 public constant TRANSFER_REQUEST_ID = 1;

    mapping(uint256 => address) public idToAddress;
    mapping(address => uint256) public addressToId;

    error VerificationFailed(address sender);
    error ProofAlreadyUsed(uint64 requestId, address sender);

    constructor(address _dapp, address _inputBox) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, _dapp);
        _grantRole(DAPP_ROLE, _dapp);
        inputBox = _inputBox;
    }

    function pause() public onlyRole(DAPP_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(DAPP_ROLE) {
        _unpause();
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

    // The following functions are required by Polygon ID.

    function _beforeProofSubmit(
        uint64 /* requestId */,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal view override {
        // check that  challenge input is address of sender
        address addr = PrimitiveTypeUtils.int256ToAddress(
            inputs[validator.inputIndexOf("challenge")]
        );
        // this is linking between msg.sender and
        if (_msgSender() != addr) revert VerificationFailed(_msgSender());
    }

    function _afterProofSubmit(
        uint64 requestId,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal override {
        IInputBox(inputBox).addInput(
            _msgSender(),
            abi.encodePacked(msg.sig, _msgSender())
        );
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Pausable, ERC1155Supply) {
        super._update(from, to, ids, values);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
