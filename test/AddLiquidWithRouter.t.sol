// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {AddLiquidWithRouter} from "../src/AddLiquidWithRouter.sol";
import "../src/interfaces/IUniswapV2Pair.sol";

contract AddLiquidWithRouterTest is Test {
    AddLiquidWithRouter public addLiquidWithRouterAddress;

    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    function setUp() public {
        addLiquidWithRouterAddress = new AddLiquidWithRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        // transfers 1 ETH to addLiquidWithRouterAddress
        vm.deal(address(addLiquidWithRouterAddress), 1 ether);

        // transfers 1000 USDC to addLiquidWithRouterAddress
        vm.prank(0x4B16c5dE96EB2117bBE5fd171E4d203624B014aa);
        IUniswapV2Pair(usdc).transfer(address(addLiquidWithRouterAddress), 1000 * 10 ** 6);
    }

    function test_AddLiquidityWithRouter() public {
        uint256 deadline = block.timestamp + 1 minutes;

        vm.prank(address(0xb0b));
        addLiquidWithRouterAddress.addLiquidityWithRouter(usdc, deadline);

        uint256 puzzleBal = IUniswapV2Pair(pool).balanceOf(address(0xb0b));

        require(puzzleBal > 0);
    }
}
