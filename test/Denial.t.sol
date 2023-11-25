// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/Denial/Denial.sol";
import "../src/levels/Denial/DenialFactory.sol";
import "../src/attack/DenialAttack.sol";

contract DenialTest is Test {
    DenialFactory public factory;
    Denial public instance;
    DenialAttack public attack;
    address public player = address(0x01);

    function setUp() public {
        vm.deal(address(this), 1 ether);
        factory = new DenialFactory();
        instance = Denial(payable(factory.createInstance{value: 1 ether}(player)));
        attack = new DenialAttack(address(instance));
    }

    function testDenialAttack() public {
        assertTrue(factory.validateInstance((payable(address(instance))), player));
    }
}
