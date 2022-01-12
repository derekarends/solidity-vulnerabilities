// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title ScoreMemory
 * @dev This contract will demo using memory
 */
contract ScoreMemory
{
    // This is still stored as storage
    int[] public scores;
 
    /// Puts two numbers in the scores array
    function insertAndUpdateScores() public
    {
        scores.push(27);
        scores.push(42);
 
        // newCounts will be a copy of the values from scores
        int[] memory newScores = scores;
        newScores[0] = 0;
    } 
}