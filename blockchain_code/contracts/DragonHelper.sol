pragma solidity >=0.5.0 <0.6.0;

import "./DragonFeeding.sol";

contract DragonHelper is DragonFeeding {

  modifier aboveLevel(uint _level, uint _dragonId) {
    require(dragons[_dragonId].level >= _level);
    _;
  }

  function changeName(uint _dragonId, string calldata _newName) external aboveLevel(2, _dragonId) {
    require(msg.sender == dragonToOwner[_dragonId]);
    dragons[_dragonId].name = _newName;
  }

  function changeDna(uint _dragonId, uint _newDna) external aboveLevel(20, _dragonId) {
    require(msg.sender == dragonToOwner[_dragonId]);
    dragons[_dragonId].dna = _newDna;
  }

  function getDragonsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerDragonCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < dragons.length; i++) {
      if (dragonToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
