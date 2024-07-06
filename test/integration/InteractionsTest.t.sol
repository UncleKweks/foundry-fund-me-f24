// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address owner;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; // 100000000000000000
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        owner = address(this);
        vm.deal(USER, STARTING_BALANCE);

        console.log("FundMe address: %s", address(fundMe));
        console.log("Owner address: %s", owner);
        console.log("USER address: %s", USER);
        console.log("USER balance: %s", USER.balance);
    }

    function testUserCanFundInteractions() public {
        vm.startPrank(USER);
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        console.log(
            "FundMe contract balance after funding: %s",
            address(fundMe).balance
        );
        console.log("User balance after funding: %s", USER.balance);

        vm.stopPrank();

        vm.startPrank(owner);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        console.log(
            "FundMe contract balance after withdrawal: %s",
            address(fundMe).balance
        );

        vm.stopPrank();

        assert(address(fundMe).balance == 0);
    }
}
