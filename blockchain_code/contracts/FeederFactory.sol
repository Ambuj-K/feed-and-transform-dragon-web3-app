pragma solidity >=0.5.0 <0.6.0;

contract FeederFactory {

    event NewFeeder(uint feederId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Feeder {
        string name;
        uint dna;
    }

    Feeder[] public feeders;

    mapping (uint => address) public feederToOwner;
    mapping (address => uint) ownerFeederCount;

    function _createFeeder(string memory _name, uint _dna) internal {
        uint id = feeders.push(Feeder(_name, _dna)) - 1;
        feederToOwner[id] = msg.sender;
        ownerFeederCount[msg.sender]++;
        emit NewFeeder(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomFeeder(string memory _name) public {
        require(ownerFeederCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createFeeder(_name, randDna);
    }

}
