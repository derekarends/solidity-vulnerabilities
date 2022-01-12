// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title ScoreStorage
 * @dev This contract will demo using storage
 */
contract ScoreStorage
{
    // Stored as storage
    int[] public scores;
 
    /// Puts two numbers in the scores array
    function insertAndUpdateScores() public
    {
        scores.push(27);
        scores.push(42);
 
        // newCounts will still be referencing counts
        int[] storage newScores = scores;
        newScores[0] = 0;
    } 
}