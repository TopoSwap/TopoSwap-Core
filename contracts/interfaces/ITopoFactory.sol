pragma solidity >=0.5.0;

interface ITopoFactory {
    function feeTo() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function createPair(address tokenA, address tokenB) external returns (address pair);
}
