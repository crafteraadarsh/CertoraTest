methods {
    function balanceOf(address) external returns(uint) envfree;
    function transferFromAcc1ToAcc2(address,address,uint) external envfree;
}

//// Rule: Transfer should correctly update balances
rule transferUpdatesBalances {
    address acc1; address acc2; uint amount;
    env e; // Declare environment variable

    // Capture balances before transfer
    mathint balance_acc1_before = balanceOf(acc1);
    mathint balance_acc2_before = balanceOf(acc2);

    // Execute transfer with environment
    transferFromAcc1ToAcc2(acc1, acc2, amount);

    // Capture balances after transfer
    mathint balance_acc1_after = balanceOf(acc1);
    mathint balance_acc2_after = balanceOf(acc2);

    // Assert balances are updated correctly
    assert balance_acc1_after == balance_acc1_before - amount,
        "Balance of acc1 should decrease by amount after transfer";

    assert balance_acc2_after == balance_acc2_before + amount,
        "Balance of acc2 should increase by amount after transfer";
}
