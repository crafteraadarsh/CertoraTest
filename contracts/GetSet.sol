// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GetSet {

    mapping(address => uint) private balances;

    function set(uint x) public {
        balances[msg.sender] = x;
    }

    function get() public view returns (uint) {
        return balances[msg.sender];
    }
    
    function balanceOf(address account) public view returns (uint) {
        return balances[account];
    }

    function transferFromAcc1ToAcc2(address acc1, address acc2, uint amount) public {
        require(balances[acc1] >= amount, "Insufficient balance");

        balances[acc1] -= amount;
        balances[acc2] += amount;
    }
}
