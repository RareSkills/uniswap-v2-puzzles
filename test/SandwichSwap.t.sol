// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Attacker, Victim} from "../src/SandwichSwap.sol";
import "../src/interfaces/IERC20.sol";

contract SandwichSwapTest is Test {
    Attacker public attacker;
    Victim public victim;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    function setUp() public {
        attacker = new Attacker();
        victim = new Victim(router);

        // set initial balance for attacker and victim contract
        vm.startPrank(0xF04a5cC80B1E94C69B48f5ee68a08CD2F09A7c3E);
        IERC20(weth).transfer(address(attacker), 1000 ether);
        IERC20(weth).transfer(address(victim), 1000 ether);
        vm.stopPrank();
    }

    function test_PerformSandwichAttack() public {
        vm.prank(address(victim));
        IERC20(weth).approve(router, 1000 ether);

        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = usdc;

        attacker.frontrun(router, weth, usdc);
        victim.performSwap(path);
        attacker.backrun(router, weth, usdc);

        uint256 attackerBal = IERC20(weth).balanceOf(address(attacker));
        require(attackerBal > 1000 ether, "Sandwich Attack Failed.");
    }
}
