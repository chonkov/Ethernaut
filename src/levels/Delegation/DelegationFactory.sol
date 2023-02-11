// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../base/Factory.sol";
import "./Delegation.sol";

contract DelegationFactory is Factory {
    address public delegateAddress;

    constructor() public {
        Delegate delegate = new Delegate(address(0));
        delegateAddress = address(delegate);
    }

    function createInstance(address _player) public payable override returns (address) {
        _player;
        Delegation delegation = new Delegation(delegateAddress);
        return address(delegation);
    }

    function validateInstance(address payable _instance, address _player) public override returns (bool) {
        Delegation delegation = Delegation(_instance);
        return delegation.owner() == _player;
    }
}
