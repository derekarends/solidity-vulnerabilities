// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title SecureContract
 * @dev This contract is demostrates how to prevent a denial of service (DoS) attack
 */
contract SecureContract {
    address payable leader;
    uint256 public highestBid;
    mapping(address => uint256) refunds;

    /// Place a bid to the contract and if it is the highest bid
    /// send the previous leader the current bid and set the leader
    /// to the sender with the new highest bid
    function bid() external payable {
        require(msg.value > highestBid);

        refunds[leader] = refunds[leader] + highestBid;

        leader = payable(msg.sender);
        highestBid = msg.value;
    }

    /// Helper function to check leader
    function getLeader() external view returns (address) {
        return leader;
    }

    /// Allow senders to retrieve their refunds
    function withdrawRefund() external payable {
        require(refunds[msg.sender] > 0, "No refunds available");

        (bool success, ) = msg.sender.call{value: refunds[msg.sender]}("");
        require(success, "Failed to transfer refund");
    }
}

/**
 * @title AttackerContract
 * @dev This contract will attack the vulnerable contract to demo DoS
 */
contract AttackerContract {
    SecureContract secureContract;

    constructor(SecureContract _secureContract) {
        secureContract = _secureContract;
    }

    /// Prevent this contract from taking ETH
    fallback() external payable {
        revert();
    }

    /// Place a bid to the vulnerable contract
    function placeBid() external payable {
        require(msg.value > secureContract.highestBid());

        secureContract.bid{value: msg.value}();
    }
}