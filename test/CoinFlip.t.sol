// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/CoinFlip/CoinFlip.sol";
import "../src/levels/CoinFlip/CoinFlipFactory.sol";
import "../src/attack/CoinFlipAttack.sol";

contract CoinFlipTest is Test {
    CoinFlipFactory public factory;
    CoinFlip public instance;
    CoinFlipAttack public attack;
    address public player = address(0x01);
    address public attacker = address(0x02);

    function setUp() public {
        factory = new CoinFlipFactory();
        instance = CoinFlip(factory.createInstance(player));
        attack = new CoinFlipAttack(address(instance));

        assertTrue(attack.target() == instance);
    }

    function testCoinFlipAttack() public {
        // SETUP
        vm.startPrank(attacker);

        // EXPLOIT
        for (uint256 i; i < 10; i++) {
            // After we flip, we need to wait for the next block, otherwise in 'CoinFlip' contract on
            // line 20 the if statement will be executed and on the very next line the tx will revert
            vm.roll(block.number + 1);
            attack.flip();
        }

        assertTrue(factory.validateInstance((payable(address(instance))), player));
    }
}
