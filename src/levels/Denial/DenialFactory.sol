// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../base/Factory.sol";
import "./Denial.sol";

contract DenialFactory is Factory {
    uint256 public initialDeposit = 0.001 ether;

    function createInstance(address _player) public payable override returns (address) {
        _player;
        require(msg.value >= initialDeposit);
        Denial instance = new Denial();
        (bool result,) = address(instance).call{value: msg.value}("");
        require(result);
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public override returns (bool) {
        _player;
        Denial instance = Denial(_instance);

        // fix the gas limit for this call
        (bool result,) = address(instance).call{gas: 5_077_383}(abi.encodeWithSignature("withdraw()"));
        return !result;
    }

    receive() external payable {}
}
