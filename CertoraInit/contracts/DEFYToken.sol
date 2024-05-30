// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./../contracts/ERC20.sol";
import "./../contracts/Pausable.sol";
import "./../contracts/Ownable.sol";

/// @custom:security-contact security@defylabs.xyz
contract DEFYToken is ERC20, Pausable, Ownable {
    constructor() ERC20("DEFY", "DEFY") {
        _mint(msg.sender, 2500000000 * 10 ** decimals());
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}