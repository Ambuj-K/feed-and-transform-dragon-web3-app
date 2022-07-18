pragma solidity ^0.8.0;

import "./DragonAttack.sol";
import "./ERC721.sol";
import "./SafeMath.sol";

/// @title A contract to transfer dragon ownership
/// @author Ambuj Kumar
/// @dev Complaint with OpenZeppelin's ERC21 spec draft
contract DragonOwnership is DragonAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) dragonApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerDragonCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return dragonToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerDragonCount[_to] = ownerDragonCount[_to].add(1);
    ownerDragonCount[msg.sender] = ownerDragonCount[msg.sender].sub(1);
    dragonToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (dragonToOwner[_tokenId] == msg.sender || dragonApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    dragonApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
