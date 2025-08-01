// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Sync, Skim} from "../src/SyncAndSkim.sol";
import "../src/interfaces/IUniswapV2Pair.sol";

contract SyncAndSkimTest is Test {
    Sync public sync;
    Skim public skim;
    address public pool = 0x8A4c8008837366d5942D2Fa96d98f55CAF3adCa9;
    address public rebase = 0x109909e1E4CeB8A89274bbdA937b02c3c62828c2;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    uint256 r0;
    uint256 r1;

    function setUp() public {
        vm.rollFork(20055371);
        (r0, r1,) = IUniswapV2Pair(pool).getReserves();
    }

    function test_PerformSync() public {
        sync = new Sync();

        // simulate negative rebase
        vm.startPrank(pool);
        IUniswapV2Pair(rebase).transfer(address(0xdead), 1000 ether);
        IUniswapV2Pair(weth).transfer(address(0xdead), 20 ether);
        vm.stopPrank();

        sync.performSync(pool);

        uint256 wethBal = IUniswapV2Pair(weth).balanceOf(pool);
        uint256 rebaseBal = IUniswapV2Pair(rebase).balanceOf(pool);

        (uint256 r00, uint256 r11,) = IUniswapV2Pair(pool).getReserves();

        require(rebaseBal == r00 && wethBal == r11, "Sync Failed.");
    }

    function test_PerformSkim() public {
        skim = new Skim();

        // Deal 0xBeeb with some tokens
        deal(rebase, address(0xBeeb), 2500 ether);
        deal(weth, address(0xBeeb), 450 ether);

        // simulate positive rebase
        vm.startPrank(address(0xBeeb));
        IUniswapV2Pair(weth).transfer(pool, 450 ether);
        IUniswapV2Pair(rebase).transfer(pool, 2500 ether);
        vm.stopPrank();

        skim.performSkim(pool);

        uint256 wethBal = IUniswapV2Pair(weth).balanceOf(pool);
        uint256 rebaseBal = IUniswapV2Pair(rebase).balanceOf(pool);

        require(rebaseBal == r0 && wethBal == r1, "Skim Failed.");

        uint256 wethPuzzleBal = IUniswapV2Pair(weth).balanceOf(address(skim));
        uint256 rebasePuzzleBal = IUniswapV2Pair(rebase).balanceOf(address(skim));

        require(wethPuzzleBal > 0 && rebasePuzzleBal > 0, "Pool Differences Not Sent To Skim Contract.");
    }
}
