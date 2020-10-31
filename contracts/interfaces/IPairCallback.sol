pragma solidity >=0.5.0;

interface IPairCallback {
    function onAddLiquidity(address user, uint amount0, uint amount1, uint lpAmount, uint feeLp) external;
    function onRemoveLiquidity(address user, uint amount0, uint amount1, uint lpAmount, uint feeLp) external;
    function onTransfer(address from, address to, uint amount) external;
}
