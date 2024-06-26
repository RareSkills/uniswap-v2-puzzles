// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {HelloWorld} from "../src/HelloWorld.sol";

contract HelloWorldTest is Test {
    HelloWorld public helloWorld;

    function setUp() public {
        helloWorld = new HelloWorld();
    }

    function test_SayHelloWorld() public {
        string memory greetings = helloWorld.sayHelloWorld(0x3e4B43D8bF9d69d2f142c39575fAD96E67c8Dc05);

        require(keccak256(abi.encodePacked(greetings)) == keccak256(abi.encodePacked("Hello World")));
    }
}
