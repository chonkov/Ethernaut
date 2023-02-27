// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/Elevator/Elevator.sol";
import "../src/levels/Elevator/ElevatorFactory.sol";
import "../src/attack/ElevatorAttack.sol";

contract ElevatorTest is Test {
    ElevatorFactory public factory;
    Elevator public instance;
    ElevatorAttack public attack;
    address public player = address(0x01);

    function setUp() public {
        factory = new ElevatorFactory();
        instance = Elevator(factory.createInstance(player));
        attack = new ElevatorAttack();
    }

    function testElevatorAttack() public {
        attack.attack(address(instance));
        assertTrue(factory.validateInstance((payable(address(instance))), player));
    }
}
