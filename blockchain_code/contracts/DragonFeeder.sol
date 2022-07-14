pragma solidity >=0.5.0 <0.6.0;

import "./DragonFactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract DragonFeeding is DragonFactory {

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Dragon storage _zombie) internal {
    _feeder.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Dragon storage _feeder) internal view returns (bool) {
      return (_feeder.readyTime <= now);
  }

  function feedAndMultiply(uint _feederId, uint _targetDna, string memory _species) internal {
    require(msg.sender == zombieToOwner[_feederId]);
    Zombie storage myDragon = zombies[_feederId];
    require(_isReady(myDragon));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myDragon.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createDragon("NoName", newDna);
    _triggerCooldown(myDragon);
  }

  function feedOnKitty(uint _feederId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_feederId, kittyDna, "kitty");
  }

}
