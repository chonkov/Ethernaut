// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/King/King.sol";
import "../src/levels/King/KingFactory.sol";
import "../src/attack/KingAttack.sol";

contract KingTest is Test {
    KingFactory public factory;
    address public instance;
    KingAttack public attack;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        assertTrue(player.balance == 0);
        vm.deal(player, 10 ether);

        factory = new KingFactory();
        vm.startPrank(player);
        instance = factory.createInstance{value: 1 ether}(player);
        vm.stopPrank();
    }

    function testKingAttack() public {
        assertTrue(attacker.balance == 0);
        vm.deal(attacker, 10 ether);

        vm.startPrank(attacker);
        attack = new KingAttack();

        attack.attack{value: 2 ether}(instance);
        vm.stopPrank();

        vm.deal(address(factory), 10 ether);

        assertTrue(factory.validateInstance(payable(instance), attacker));
        assertTrue(King(payable(instance))._king() == address(attack));
    }
}
