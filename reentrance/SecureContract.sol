// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title SecureContract
 * @dev Used to demonstrate a contract who is secure from a reentrance attack
 */
// 1: Use Openzeppelin's ReentrancyGuard
contract SecureContract is ReentrancyGuard {
    mapping(address => uint256) public balances;
    /// Allow senders to deposit ETH
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // 1: Add the nonReentrant modifier from Openzeppelin
    // 3: Name functions that are making external calls as untrusted
    /// Allow senders to withdraw their ETH
    function withdrawUntrusted() external nonReentrant {
        uint256 bal = balances[msg.sender];
        require(bal > 0);
        
        // 2: Update the state of the msg.send before the external call
        // Clear out the senders balance
        balances[msg.sender] = 0;
        
        // Vulnerability: Calling out to the sender to send them their ETH
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
    }
    
    /// Check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}