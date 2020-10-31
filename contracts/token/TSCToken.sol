// SPDX-License-Identifier: SimPL-2.0
pragma solidity 0.6.0;

import '../interfaces/IERC20.sol';
import './TokenStorage.sol';

contract TSCToken is TokenStorage, IERC20 {
    using SafeMath for uint256;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(isOwner(), "Caller is not the owner");
        _;
    }
    modifier onlyIssuer() {
        require(issuer[msg.sender], "The caller does not have issuer role privileges");
        _;
    }

    constructor () public {
        _name = 'Topo Swap Coin';
        _symbol = 'TSC';
        _decimals = 18;

        owner = msg.sender;
        issuer[msg.sender] = true;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function name() external view returns (string memory) {
        return _name;
    }
    function symbol() external view returns (string memory) {
        return _symbol;
    }
    function decimals() external view returns (uint8) {
        return _decimals;
    }
    function totalSupply() external override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external override view returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function allowance(address _owner, address spender) external override view returns (uint256) {
        return _allowances[_owner][spender];
    }
    function approve(address spender, uint256 value) external override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    function issue(address account, uint256 amount) external onlyIssuer returns (bool) {
        _mint(account, amount);
        return true;
    }
    function burn(uint256 amount) external onlyIssuer returns (bool) {
        _burn(msg.sender, amount);
        return true;
    }

    function addIssuer(address _addr) public onlyOwner returns (bool){
        require(_addr != address(0), "address cannot be 0");
        if (issuer[_addr] == false) {
            issuer[_addr] = true;
            return true;
        }
        return false;
    }
    function removeIssuer(address _addr) public onlyOwner returns (bool) {
        require(_addr != address(0), "address cannot be 0");
        if (issuer[_addr] == true) {
            issuer[_addr] = false;
            return true;
        }
        return false;
    }

    // Internal functions
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }
    function _approve(address _owner, address spender, uint256 value) internal {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[_owner][spender] = value;
        emit Approval(_owner, spender, value);
    }
}