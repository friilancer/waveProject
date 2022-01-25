// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "hardhat/console.sol" ;

contract WavePortal{
    uint256 totalWaves;

    uint256 private seed;

    struct Waver{
        uint256 waves;
    }

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => Waver) public wavers;
    mapping(address => uint256) public lastWavedAt;

    constructor() payable{
        console.log("New smart contract alert");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public{

        require(
            lastWavedAt[msg.sender] + 45 seconds < block.timestamp,
            "Wait for 45 Seconds"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves+=1;
        Waver storage sender = wavers[msg.sender];
        sender.waves +=1;
        console.log(msg.sender, "has waved", sender.waves, "times");
        waves.push(Wave(msg.sender, _message, block.timestamp));
        emit NewWave(msg.sender, block.timestamp, _message);

        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        if(seed <= 50 ) {
            console.log("%s won!", msg.sender);
            uint256 prizeMoney = 0.0001 ether;
            require(
                prizeMoney <= address(this).balance,
                "Trying to withdraw more money than the contract has"
            );
            (bool success,) = (msg.sender).call{value: prizeMoney}("");
            require(
                success,
                "Failed to withdraw money from contract"
            );
        }
    }

    function getAllWaves() public view returns (Wave[] memory){
        return waves;
    }

    function getTotalWaves() public view returns (uint256){
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}