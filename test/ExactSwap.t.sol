// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ExactSwap} from "../src/ExactSwap.sol";
import "../src/interfaces/IUniswapV2Pair.sol";

contract ExactSwapTest is Test {
    ExactSwap public exactSwap;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    function setUp() public {
        vm.rollFork(20055371);

        exactSwap = new ExactSwap();

        // transfers 1 WETH to exactSwap contract
        vm.prank(0xF04a5cC80B1E94C69B48f5ee68a08CD2F09A7c3E);
        IUniswapV2Pair(weth).transfer(address(exactSwap), 1 ether);
    }

    function test_PerformExactSwap() public {
        (uint256 r0, uint256 r1,) = IUniswapV2Pair(pool).getReserves();

        vm.prank(address(0xb0b));
        exactSwap.performExactSwap(pool, weth, usdc);

        uint256 foo = (1 ether) - (IUniswapV2Pair(weth).balanceOf(address(exactSwap)));

        uint256 d = (foo * 997 * r0) / ((r1 * 1000) + (997 * foo));

        uint256 puzzleBal = IUniswapV2Pair(usdc).balanceOf(address(exactSwap));

        require(puzzleBal / 1e6 == 1337, "Puzzle Balance Not 1337 USDC.");
        require(d / 1e6 == 1337, "Did Not Swap Exact Amount Of WETH.");
    }
}
