// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../base/Factory.sol";
import "./Telephone.sol";

contract TelephoneFactory is Factory {
    function createInstance(address _player) public payable override returns (address) {
        _player;
        Telephone instance = new Telephone();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public override returns (bool) {
        Telephone instance = Telephone(_instance);
        return instance.owner() == _player;
    }
}
