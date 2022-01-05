// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title VulnerableContract
 * @dev Used to demonstrate a contract vulnerable to a reentrance attack
 */
contract VulnerableContract {
    mapping(address => uint256) public balances;

    /// Allow senders to deposit ETH
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /// Allow senders to withdraw their ETH
    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0);

        // Vulnerability: Calling out to the sender to send them their ETH
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        // Clear out the senders balance
        balances[msg.sender] = 0;
    }

    /// Check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}