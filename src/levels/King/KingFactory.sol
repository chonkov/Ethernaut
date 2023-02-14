// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../base/Factory.sol";
import "./King.sol";

contract KingFactory is Factory {
    uint256 public constant INITIAL_VALUE = 1 ether;

    function createInstance(address _player) public payable override returns (address) {
        _player;
        require(msg.value >= INITIAL_VALUE, "Did not send the minimum amount");
        return address((new King){value: msg.value}());
    }

    function validateInstance(address payable _instance, address _player) public override returns (bool) {
        _player;
        King instance = King(_instance);
        (bool result,) = address(instance).call{value: 0}("");
        return instance._king() != address(this);
    }

    receive() external payable {}
}
