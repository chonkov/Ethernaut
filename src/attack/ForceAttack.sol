// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../levels/Force/Force.sol";

contract ForceAttack {
    constructor(address payable target) public payable {
        selfdestruct(target);
    }
}
