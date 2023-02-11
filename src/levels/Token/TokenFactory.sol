// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../base/Factory.sol";
import "./Token.sol";

contract TokenFactory is Factory {
    uint256 constant INITIAL_SUPPLY = 1_000_000;
    uint256 constant PLAYER_SUPPLY = 20;

    function createInstance(address _player) public payable override returns (address) {
        _player;
        Token instance = new Token(INITIAL_SUPPLY);
        instance.transfer(_player, PLAYER_SUPPLY);
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public override returns (bool) {
        Token instance = Token(_instance);
        return instance.balanceOf(_player) > PLAYER_SUPPLY;
    }
}
