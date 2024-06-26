// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BurnLiquidWithRouter} from "../src/BurnLiquidWithRouter.sol";
import "../src/interfaces/IUniswapV2Pair.sol";

contract BurnLiquidWithRouterTest is Test {
    BurnLiquidWithRouter public burnLiquidWithRouterAddress;

    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;
    address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    function setUp() public {
        vm.rollFork(20055371);

        burnLiquidWithRouterAddress = new BurnLiquidWithRouter(router);

        // transfers 0.01 UNI-V2-LP to BurnLiquidWithRouterAddress
        vm.prank(0x18498Ab9931c671742C4fF0CA292c1876CaB7384);
        IUniswapV2Pair(pool).transfer(address(burnLiquidWithRouterAddress), 0.01 ether);
    }

    function test_BurnLiquidityWithRouter() public {
        uint256 deadline = block.timestamp + 1 minutes;

        vm.prank(address(0xb0b));
        burnLiquidWithRouterAddress.burnLiquidityWithRouter(pool, usdc, weth, deadline);

        uint256 usdcBal = IUniswapV2Pair(usdc).balanceOf(address(burnLiquidWithRouterAddress));
        uint256 wethBal = IUniswapV2Pair(weth).balanceOf(address(burnLiquidWithRouterAddress));

        assertEq(usdcBal, 1432558576085);
        assertEq(wethBal, 388231892770818155977);
    }
}
