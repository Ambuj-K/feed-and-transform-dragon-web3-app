pragma solidity ^0.8.0;

import "./Ownable.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract DragonFactory is Ownable, VRFConsumerbase {

    event NewDragon(uint dragonId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    
    bytes32 public keyHash;
    uint256 public fee;
    uint256 public randomResult;

    struct Dragon {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }

    Dragon[] public dragons;
    
    constructor() VRFConsumerBase(
      0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
      0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
    ) public{
      keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
      fee = 100000000000000000;

    }

    mapping (uint => address) public dragonToOwner;
    mapping (address => uint) ownerDragonCount;

    function _createDragon(string memory _name, uint _dna) internal {
      uint id = dragons.push(Dragon(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
      dragonToOwner[id] = msg.sender;
      ownerDragonCount[msg.sender]++;
      emit NewDragon(id, _name, _dna);
    }
    
    function _generateRandomDna() public returns (bytes32 requestId) {
      return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
      randomResult = randomness;
    }

    function createRandomDragon(string memory _name) public {
      require(ownerDragonCount[msg.sender] == 0);
      uint randDna = _generateRandomDna();
      _createDragon(_name, randDna);
    }

}
