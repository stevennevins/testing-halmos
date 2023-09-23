// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {Test} from "forge-std/Test.sol";

address constant OWNER = address(69);

contract CheckSender {
    function onlyOwner() external view {
        if (msg.sender!=OWNER) revert ("Not Owner");
    }
}

contract SenderSpec is SymTest, Test {
    address internal checkSender;
    function setUp() public {
        checkSender = address(new CheckSender());
    }

    function check_caller(bytes4 selector, address caller) public {
        /// comment out this line out, and halmos can find the address and the function selector 
        vm.assume(caller != OWNER);

        bytes memory data = abi.encodeWithSelector(selector, "");
        vm.prank(caller);
        (bool success,) = address(checkSender).call(data);
        assertFalse(success);
    }

    function testFuzz_caller(bytes4 selector, address caller) public {
        /// comment out this line out. The fuzzer cant find the address and the function selector 
        vm.assume(caller != OWNER);

        bytes memory data = abi.encodeWithSelector(selector, "");
        vm.prank(caller);
        (bool success,) = address(checkSender).call(data);
        assertFalse(success);
    }
}
