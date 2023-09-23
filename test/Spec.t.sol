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

    function check_caller() public {
        address caller = svm.createAddress('caller');
        /// comment out this line out, and halmos can find the address and the function selector 
        vm.assume(caller != OWNER);
        vm.prank(caller);
        bytes memory data = svm.createBytes(4, 'data');
        (bool success,) = address(checkSender).call(data);
        assert(!success);
    }
}
