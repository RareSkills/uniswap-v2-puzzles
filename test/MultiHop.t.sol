// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MultiHop} from "../src/MultiHop.sol";
import "../src/interfaces/IERC20.sol";

contract MultiHopTest is Test {
    MultiHop public multiHop;

    uint256 expectedBal = 124357294480590334683528460202;

    address public mkr = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public elon = 0x761D38e5ddf6ccf6Cf7c55759d5210750B5D60F3;

    function setUp() public {
        vm.rollFork(20055371);

        multiHop = new MultiHop(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        // transfers 10 MKR to multiHop contract
        vm.prank(0x0a3f6849f78076aefaDf113F5BED87720274dDC0);
        IERC20(mkr).transfer(address(multiHop), 10 ether);
    }

    function test_PerformMultiHopWithRouter() public {
        uint256 deadline = block.timestamp + 1 minutes;

        vm.prank(address(0xb0b));
        multiHop.performMultiHopWithRouter(mkr, weth, elon, deadline);

        uint256 puzzleBal = IERC20(elon).balanceOf(address(multiHop));

        require(puzzleBal == expectedBal, "Insufficient ELON Balance.");
    }
}
