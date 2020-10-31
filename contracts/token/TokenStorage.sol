// SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.6.0;

contract TokenStorage {
    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) internal _allowances;
    uint256 internal _totalSupply;
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    address owner;
    mapping(address => bool) internal issuer;
}