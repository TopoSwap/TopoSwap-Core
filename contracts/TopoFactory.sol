pragma solidity =0.5.16;

import './interfaces/ITopoFactory.sol';
import './TopoPair.sol';

contract TopoFactory is ITopoFactory {
    address public feeTo;
    address public setter;
    address public callBack;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _setter, address _feeTo) public {
        require(_setter != address(0), 'SETTER INVALID');
        setter = _setter;
        feeTo = _feeTo;
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == setter, 'FORBIDDEN');
        feeTo = _feeTo;
    }
    
    function setCallback(address _callBack) external {
        require(msg.sender == setter, 'FORBIDDEN');
        callBack = _callBack;
    }
    
    function setPairCallback(address pair, bool enable) external {
        require(msg.sender==setter || msg.sender==callBack, 'FORBIDDEN');
        if (enable) {
            ITopoPair(pair).setCallback(callBack);
        }
        else {
            ITopoPair(pair).setCallback(address(0));
        }
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'PAIR_EXISTS');

        // single check is sufficient
        bytes memory bytecode = type(TopoPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        ITopoPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }
}
