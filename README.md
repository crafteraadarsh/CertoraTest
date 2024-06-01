# Certora

To run this **Certora Spec** First Clone this repo using:
```shell
git clone https://github.com/crafteraadarsh/Certora.git
``` 
# How To SetUp Certora
Use, Sol version 0.8.0 or higher using,
```
solc-select use 0.8.19
```
Install Certora using :
```
pip3 install certora-cli
```
Then, Before running the Prover, you should register your access key as a system variable. To do so on macOS or Linux machines, execute the following command on the terminal:
```
export CERTORAKEY=<personal_access_key>
```
Now, Change your environment to the cloned repo using,
```
cd CertoraTest
```

# Repo Overview

Run Certora Prover by Using,
```
certoraRun ./certora/conf/default.conf
```
* **default.conf** is used as a medium to set relation between our sol contract and our spec file written in **CVL(Certora verification language)**. Here, DEFYToken.sol is our contract and ERC20t.spec is our spec file and these can be altered as users wish.
```
{
  "files": [
    "contracts/DEFYToken.sol"
  ],
  "verify": "DEFYToken:certora/spec/ERC20.spec",
  "msg": "ERC20Rules",
  "mutations": {
    "gambit": [
       {
            "filename" : "contracts/DEFYToken.sol",
            "num_mutants": 5
       }
    ],
    "msg": "basic mutation configuration"
    }
}
```
# Spec Details 

This spec file is written for a **Erc20** and covers the formal verification tests to check the behaviour of an **Erc20 Contract**.
Till Now we can test for 
- Transfer must move `amount` tokens from the caller's account to `recipient`.
- Transfer must revert if the sender's balance is too small.
- Transfer must not revert unless
  the sender doesn't have enough funds,
  or the message value is nonzero,
  or the recipient's balance would overflow,
  or the message sender is 0,
  or the recipient is 0.
- If `approve` changes a holder's allowance, then it was called by the holder.
- Rule to check Balance should not change using transferFrom if allowance is not given,
  if given then Balance should only update as per the transferfrom,
  and allowance should get reduced by that number.
# Improvements: 
- only the token holder or an approved third party can reduce an account's balance.
- only the token holder (or a permit) can increase allowance. The spender can decrease it by using it.

## Spec Details
