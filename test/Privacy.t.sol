// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/levels/Privacy/Privacy.sol";

contract PrivacyTest {
    Privacy public instance;

    function setUp() public {
        bytes32[3] memory data;
        data[0] = keccak256("Super private data 1");
        data[1] = keccak256("Super private data 2");
        data[2] = keccak256("Super private data 3");
        instance = new Privacy(data);
    }

    function attack(bytes32 password) public {
        //   bytes32 password = 0xd25dbd59cc016b81fe4dff9b6ae2044470b25990a5f8fc43dc7b25c67d3b138d;
        instance.unlock(bytes16(password));

        assert(!instance.locked());
    }
}

// Steps to hacking the vault contract using cast and anvil:
//    $ anvil
//    $ export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 (First unlocked account's private key in foundry)
//    $ forge create --private-key $PRIVATE_KEY test/Privacy.t.sol:PrivacyTest
//    $ cast send --private-key $PRIVATE_KEY <TEST_CONTRACT_ADDRESS> 0x0a9254e4 (Function selector of the 'setUp' function)
//    $ cast storage <TEST_CONTRACT_ADDRESS> 0 (SLOT_ZERO)
//    $ cast storage <TARGET_CONTRACT_ADDRESS> 5 (SLOT_FIVE)
//    $ cast send --private-key $PRIVATE_KEY <TEST_CONTRACT_ADDRESS> <FUNC_SELECTOR> <ARGS_PASSED_TO_THE_ATTACK_FUNC>
