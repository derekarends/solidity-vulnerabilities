// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title VulnerableContract
 * @dev Used to show what a contract vulnerable to forced ETH looks like
 */
contract VulnerableContract {
    /// Owner of the contract
    address public owner;

    /// Construct the contract specifying who will be the owner.
    constructor(address _owner) {
        owner = _owner;
    }

    /// This is used to handle calls from send, transfer, call
    /// however, this will not get called if another contract selfdestructs
    fallback() external payable {
        revert();
    }

    /// This function is vulnerable because it is basing its check of contract balance
    function takeOwnership() external {
        require(address(this).balance > 0);
        owner = msg.sender;
    }

    /// Check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}