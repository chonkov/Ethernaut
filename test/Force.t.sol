// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/Force/Force.sol";
import "../src/levels/Force/ForceFactory.sol";
import "../src/attack/ForceAttack.sol";

contract ForceTest is Test {
    ForceFactory public factory;
    Force public instance;
    ForceAttack public attack;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        factory = new ForceFactory();
        instance = Force(factory.createInstance(player));
    }

    function testForceAttack() public {
        vm.deal(attacker, 1 ether);
        vm.startPrank(attacker);
        attack = new ForceAttack{value: 1}(payable(address(instance)));
        vm.stopPrank();

        assertTrue(factory.validateInstance((payable(address(instance))), player));
        emit log_uint(address(instance).balance);
    }
}
