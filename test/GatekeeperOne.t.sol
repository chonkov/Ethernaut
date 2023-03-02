// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/GatekeeperOne/GatekeeperOne.sol";
import "../src/levels/GatekeeperOne/GatekeeperOneFactory.sol";
import "../src/attack/GatekeeperOneAttack.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOneFactory public factory;
    GatekeeperOne public instance;
    GatekeeperOneAttack public attack;
    address public player = address(0x01);
    // 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38 is the default tx.origin that foundry uses
    // if we spin up anvil, and we can use different address in the place of <Desired_Account>
    // $ forge create --private-key $PRIVATE_KEY test/GatekeeperOne.t.sol:GatekeeperOneTest
    // $ cast send --private-key $PRIVATE_KEY <GatekeeperOne_Address> "setUp()"
    // $ cast send --private-key $PRIVATE_KEY --from <Desired_Account> <GatekeeperOne_Address> "testGatekeeperOneAttack()"
    address public attacker = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
    bytes8 internal key;

    function setUp() public {
        factory = new GatekeeperOneFactory();
        instance = GatekeeperOne(factory.createInstance(player));
        attack = new GatekeeperOneAttack();

        key = bytes8(uint64(attacker)) & 0xFFFFFFFF0000FFFF;

        assert(uint32(uint64(key)) == uint16(uint64(key)));
        assert(uint32(uint64(key)) != uint64(key));
        assert(uint32(uint64(key)) == uint16(attacker));
    }

    function testGatekeeperOneAttack() public {
        // Gas required to hack the GatekeeperOne contract is 211
        //   attack.attack(address(instance), key, 211);
        for (uint256 i = 211; i < 212; i++) {
            try attack.attack(address(instance), key, i) {
                log_uint(i);
            } catch {}
        }

        assertTrue(factory.validateInstance((payable(address(instance))), attacker));
    }
}
