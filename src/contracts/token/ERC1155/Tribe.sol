// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";

contract Tribe is ERC1155, ERC1155Pausable, AccessControl, ERC1155Burnable, ERC1155Supply {

    // id 1 is the costumers' token
    // id 2 is the investors' token

    bytes32 public constant DAPP_ROLE = keccak256("DAPP_ROLE");

    event Mint(address indexed account, uint256 id, uint256 amount);

    constructor(address _dapp) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, _dapp);
        _grantRole(DAPP_ROLE, _dapp);
    }

    function pause() public onlyRole(DAPP_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(DAPP_ROLE) {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount)
        public
        onlyRole(DAPP_ROLE)
    {   
        bytes memory data = abi.encodePacked(""); // request 
        _mint(account, id, amount, data);
        emit Mint(account, id, amount);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyRole(DAPP_ROLE)
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}