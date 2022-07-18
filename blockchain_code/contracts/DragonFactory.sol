pragma solidity ^0.8.0;

import "./Ownable.sol";

contract DragonFactory is Ownable {

    event NewDragon(uint dragonId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Dragon {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }

    Dragon[] public dragons;

    mapping (uint => address) public dragonToOwner;
    mapping (address => uint) ownerDragonCount;

    function _createDragon(string memory _name, uint _dna) internal {
        uint id = dragons.push(Dragon(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        dragonToOwner[id] = msg.sender;
        ownerDragonCount[msg.sender]++;
        emit NewDragon(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomDragon(string memory _name) public {
        require(ownerDragonCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createDragon(_name, randDna);
    }

}
