pragma solidity ^0.8.0;

import "./DragonHelper.sol";

contract DragonAttack is DragonHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _dragonId, uint _targetId) external ownerOf(_dragonId) {
    Dragon storage myDragon = dragons[_dragonId];
    Dragon storage enemyDragon = dragons[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myDragon.winCount++;
      myDragon.level++;
      enemyDragon.lossCount++;
      feedAndMultiply(_dragonId, enemyDragon.dna, "dragon");
    } else {
      myDragon.lossCount++;
      enemyDragon.winCount++;
      _triggerCooldown(myDragon);
    }
  }
}
