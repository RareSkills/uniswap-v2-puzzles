// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ExactSwapWithRouter} from "../src/ExactSwapWithRouter.sol";
import "../src/interfaces/IERC20.sol";

contract ExactSwapTest is Test {
    ExactSwapWithRouter public exactSwapWithRouter;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() public {
        vm.rollFork(20055371);

        exactSwapWithRouter = new ExactSwapWithRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        // transfers 1 WETH to exactSwapWithRouter contract
        vm.prank(0xF04a5cC80B1E94C69B48f5ee68a08CD2F09A7c3E);
        IERC20(weth).transfer(address(exactSwapWithRouter), 1 ether);
    }

    function test_PerformExactSwapWithRouter() public {
        uint256 deadline = block.timestamp + 1 minutes;

        vm.prank(address(0xb0b));
        exactSwapWithRouter.performExactSwapWithRouter(weth, usdc, deadline);

        uint256 puzzleBal = IERC20(usdc).balanceOf(address(exactSwapWithRouter));

        require(puzzleBal / 1e6 == 1337, "Puzzle Balance Not 1337 USDC.");
    }
}
