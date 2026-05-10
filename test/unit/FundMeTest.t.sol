//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 STARTING_USER_BALANCE = 10 ether;
    uint256 SEND_VALUE = 0.01 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testFundUpdatesFundedAmount() public funded {
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE);
    }

    function testUserAddedToFundersArray() public funded {
        assertEq(fundMe.getFunder(0), USER);
    }

    function testUserNotAddedTwice() public funded {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        assertEq(fundMe.getFundersLength(), 1);
    }

    function testLowEthRejection() public {
        vm.expectRevert();
        fundMe.fund{value: 0.001 ether}();
    }

    function testOnlyUserCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawUpdatesBalanceToZero() public funded {
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        assertEq(address(fundMe).balance, 0);
    }

    function testWithdrawResetsFundersAmount() public funded {
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        assertEq(fundMe.getAddressToAmountFunded(USER), 0);
    }

    function testWithdrawResetsFundersArray() public funded {
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        assertEq(fundMe.getFundersLength(), 0);
    }

    function testOwnerBalanceIncreasesAfterWithdraw() public funded {
        address owner = fundMe.getOwner();
        uint256 ownerBalanceBeforeWithdraw = address(owner).balance;
        vm.prank(owner);
        fundMe.withdraw();
        uint256 ownerBalanceAfterWithdraw = address(owner).balance;
        assertGt(ownerBalanceAfterWithdraw, ownerBalanceBeforeWithdraw);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        for (uint160 i = 1; i < numberOfFunders; i++) {
            hoax(address(uint160(i)), STARTING_USER_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = address(fundMe.getOwner()).balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        assertEq(address(fundMe).balance, 0);
        assertEq(address(fundMe.getOwner()).balance, startingOwnerBalance + startingFundMeBalance);
    }

    receive() external payable {}
}
