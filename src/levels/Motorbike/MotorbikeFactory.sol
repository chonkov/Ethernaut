// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "../base/Factory.sol";
import "./Motorbike.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

contract MotorbikeFactory is Factory {
    mapping(address => address) public engines;

    function createInstance(address _player) public payable override returns (address) {
        _player;

        Engine engine = new Engine();
        Motorbike motorbike = new Motorbike(address(engine));
        engines[address(motorbike)] = address(engine);

        return address(motorbike);
    }

    function validateInstance(address payable _instance, address _player) public override returns (bool) {
        _player;
        return !Address.isContract(engines[_instance]);
    }
}
