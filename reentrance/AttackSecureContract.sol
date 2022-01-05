// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SecureContract.sol";

/**
 * @title AttackSecureContract
 * @dev Used to demonstrate a contract how a secure contract can prevent a reentrance attack
 */
contract AttackSecureContract {
    SecureContract public secureContract;
    
    /// Initialize the Attacker contract with the address of
    /// the secure contract.
    constructor(address _secureContract) {
        secureContract = SecureContract(_secureContract);
    }
    
    // Fallback will be called when the SecureContract sends ETH to this contract.
    fallback() external payable {
        /// This will check if the secure contract still has ETH
        /// and if it does, continue to try and call withdrawUntrusted() 
        if (address(secureContract).balance >= 1 ether) {
            secureContract.withdrawUntrusted();
        }
    }
    
    /// This function will start the attack on the secure contract
    function attack() external payable {
        require(msg.value >= 1 ether);
        secureContract.deposit{value: 1 ether}();
        secureContract.withdrawUntrusted();
    }

    // Check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}