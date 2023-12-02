// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/DexTwo/DexTwo.sol";
import "../src/levels/DexTwo/DexTwoFactory.sol";
import "../src/attack/DexTwoAttack.sol";

contract DexTwoTest is Test {
    DexTwoFactory public factory;
    DexTwo public instance;
    DexTwoAttack public attack;
    address public player = address(0x01);

    function setUp() public {
        factory = new DexTwoFactory();
        instance = DexTwo(factory.createInstance(player));
        attack = new DexTwoAttack();
    }

    function testDexTwoAttack() public {
        attack.attack(instance);
        assertTrue(factory.validateInstance((payable(address(instance))), address(attack)));
    }
}
