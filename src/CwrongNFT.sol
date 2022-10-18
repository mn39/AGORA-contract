// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract CwrongNFT is ERC721 {
  string private _name;
  string private _symbol;
  mapping(address => uint256) private _ownerId;
  mapping(uint256 => address) private _owners;

  constructor(string memory named, string memory symbolified) {
    _name = named;
    _symbol = symbolified;
  }

  function name() external view returns (string memory) {
    return _name;
  }

  function symbol() external view returns (string memory) {
    return _symbol;
  }

  function totalSupply() external view returns (uint256 amount) {}

  function ownerOf(uint256 tokenId) public view returns (address) {
    address owner = _tokenOwner[tokenId];
    require(owner != address(0), "ERC721: owner query for nonexistent token");

    return owner;
  }

  function tokenURI(uint256 tokenId) public view returns (string memory) {}

  function transfer(
    address from,
    address to,
    uint256 tokenId
  ) {
    require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");

    _transferFrom(from, to, tokenId);
  }
}
