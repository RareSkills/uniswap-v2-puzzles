// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BurnLiquid} from "../src/BurnLiquid.sol";
import "../src/interfaces/IUniswapV2Pair.sol";

contract BurnLiquidTest is Test {
    BurnLiquid public burnLiquid;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    function setUp() public {
        vm.rollFork(20055371);

        burnLiquid = new BurnLiquid();

        // transfers 0.01 UNI-V2-LP to BurnLiquid contract
        vm.prank(0x18498Ab9931c671742C4fF0CA292c1876CaB7384);
        IUniswapV2Pair(pool).transfer(address(burnLiquid), 0.01 ether);
    }

    function test_BurnLiquidity() public {
        vm.prank(address(0xb0b));
        burnLiquid.burnLiquidity(pool);

        uint256 usdcBal = IUniswapV2Pair(usdc).balanceOf(address(burnLiquid));
        uint256 wethBal = IUniswapV2Pair(weth).balanceOf(address(burnLiquid));

        assertEq(usdcBal, 1432558576085);
        assertEq(wethBal, 388231892770818155977);
    }
}
