// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../base/Factory.sol";
import "./Elevator.sol";

contract ElevatorFactory is Factory {
    function createInstance(address _player) public payable override returns (address) {
        _player;
        Elevator instance = new Elevator();
        return address(instance);
    }

    function validateInstance(address payable _instance, address) public override returns (bool) {
        Elevator elevator = Elevator(_instance);
        return elevator.top();
    }
}
