// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Twap} from "../src/Twap.sol";

contract TwapTest is Test {
    Twap public twap;

    address public pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    bytes32 hashedOneHourTwap = 0x0d4d02696b9a422a88fa5a2753681597ff742148503c9d5bb45082dc84533a5e;
    bytes32 hashedOneHourTimeStamp = 0x40f46f3d5e2b2a69b9535ddec53ff94317882e3239b2c87c842e15fd6c3400e4;
    uint224 oneHourTwap;

    bytes32 hashedOneDayTwap = 0xd98b216f051dce37831561d35433019fbd7ecf66a06db5af60360c032dfa3bdc;
    bytes32 hashedOneDayTimeStamp = 0xb55fce40a7b00a5e922de6a52609e93f0157b1d54e3d82edcd5a3bdbe98b3fc8;
    uint224 oneDayTwap;

    function setUp() public {
        twap = new Twap(pool);

        //**       ONE HOUR TWAP       **//

        vm.rollFork(20055371); // start block
        twap.first1HourSnapShot();

        vm.rollFork(20055671); // (start + 1 hour) block
        oneHourTwap = twap.second1HourSnapShot();

        //**      ONE HOUR TWAP END      **//

        //**      ONE DAY TWAP       **//

        vm.rollFork(20075371); // start block
        twap.first1DaySnapShot();

        vm.rollFork(20082571); // (start + 1 day) block
        oneDayTwap = twap.second1DaySnapShot();

        //**      ONE DAY TWAP END      **//
    }

    function test_PerformOneHourTwap() public {
        require(
            keccak256(abi.encode(twap.first1HourSnapShot_TimeStamp())) == hashedOneHourTimeStamp,
            "Player Did Not Snapshot Timestamp"
        );
        require(keccak256(abi.encode(oneHourTwap)) == hashedOneHourTwap, "Incorrect One Hour TWAP.");
    }

    function test_PerformOneDayTwap() public {
        require(
            keccak256(abi.encode(twap.first1DaySnapShot_TimeStamp())) == hashedOneDayTimeStamp,
            "Player Did Not Snapshot Timestamp"
        );
        require(keccak256(abi.encode(oneDayTwap)) == hashedOneDayTwap, "Incorrect One Day TWAP.");
    }
}
