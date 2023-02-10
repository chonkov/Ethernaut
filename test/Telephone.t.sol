// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/Telephone/Telephone.sol";
import "../src/levels/Telephone/TelephoneFactory.sol";
import "../src/attack/TelephoneAttack.sol";

contract TelephoneTest is Test {
    TelephoneFactory public factory;
    address public instance;
    TelephoneAttack public attack;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        factory = new TelephoneFactory();
        instance = payable(factory.createInstance(player));
    }

    function testTelephoneAttack() public {
        vm.startPrank(attacker);
        new TelephoneAttack(instance);
        vm.stopPrank();

        assertTrue(factory.validateInstance(payable(instance), attacker));

        emit log_address(Telephone(instance).owner());
    }
}
