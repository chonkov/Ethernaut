// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/Reentrance/Reentrance.sol";
import "../src/levels/Reentrance/ReentranceFactory.sol";
import "../src/attack/ReentranceAttack.sol";

contract ReentranceTest is Test {
    ReentranceFactory public factory;
    address public instance;
    ReentranceAttack public attack;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        assertTrue(player.balance == 0);
        vm.deal(player, 10 ether);

        factory = new ReentranceFactory();

        vm.startPrank(player);
        instance = factory.createInstance{value: 2 ether}(player);
        vm.stopPrank();
    }

    function testReentranceAttack() public {
        attack = new ReentranceAttack(payable(instance));

        assertTrue(attacker.balance == 0);
        vm.deal(attacker, 10 ether);

        vm.startPrank(attacker);
        attack.donate{value: 1 ether}();
        attack.attack();
        vm.stopPrank();

        assertTrue(factory.validateInstance(payable(instance), attacker));
        assertTrue(instance.balance == 0);
        assertTrue(address(attack).balance == 3 ether);
        emit log_uint(instance.balance);
        emit log_uint(address(attack).balance);
    }
}
