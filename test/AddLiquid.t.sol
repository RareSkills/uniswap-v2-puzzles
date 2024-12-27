// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {AddLiquid} from "../src/AddLiquid.sol";
import "../src/interfaces/IUniswapV2Pair.sol";

contract AddLiquidTest is Test {
    AddLiquid public addLiquid;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    function setUp() public {
        addLiquid = new AddLiquid();

        // transfers 1 WETH to addLiquid contract
        deal(weth, address(addLiquid), 1 ether);

        // transfers 1000 USDC to addLiquid contract
        deal(usdc, address(addLiquid), 1000e6);
    }

    function test_AddLiquidity() public {
        (uint256 reserve0, uint256 reserve1,) = IUniswapV2Pair(pool).getReserves();
        uint256 _totalSupply = IUniswapV2Pair(pool).totalSupply();

        vm.prank(address(0xb0b));
        addLiquid.addLiquidity(usdc, weth, pool, reserve0, reserve1);

        uint256 foo = (1000e6) - (IUniswapV2Pair(usdc).balanceOf(address(addLiquid)));

        uint256 puzzleBal = IUniswapV2Pair(pool).balanceOf(address(0xb0b));

        uint256 bar = (foo * reserve1) / reserve0;

        uint256 expectBal = min((foo * _totalSupply) / (reserve0), (bar * _totalSupply) / (reserve1));

        require(puzzleBal > 0, "No LP tokens minted");
        assertEq(puzzleBal, expectBal, "Incorrect LP tokens received");
    }

    // Internal function
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }
}
