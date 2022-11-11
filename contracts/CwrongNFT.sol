// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interface/IView.sol";

contract CwrongNFT is ERC721 {
  address private _viewAddress;
  address private _leader;
  string private _URI;
  uint256 private _totalSupply;
  mapping(address => uint256) internal _ownerID;

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender) == true, "You are not admin");
    _;
  }

  modifier isZeroID(uint256 tokenID) {
    require(tokenID != 0, "Zero id token cannot be transfered");
    _;
  }

  constructor(address viewAddress, address leader) ERC721("CwrongGov Test", "CWGT") {
    _viewAddress = viewAddress;
    _leader = leader;
    mint(leader, 0);
  }

  function getViewAddress() public view returns (address addr) {
    return _viewAddress;
  }

  function totalSupply() public view returns (uint256 supply) {
    return _totalSupply;
  }

  function ownerID(address addr) public view returns (uint256 nftID) {
    return _ownerID[addr];
  }

  function setViewAddress(address newView) public onlyAdmin returns (address addr) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function setBaseURI(string memory baseURI) public onlyAdmin {
    _URI = baseURI;
  }

  function mint(address to, uint256 tokenId) public onlyAdmin {
    _safeMint(to, tokenId);
  }

  function _transfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override isZeroID(tokenId) {
    require(_ownerID[to] == 0, "Receiver already have.");
    super._transfer(from, to, tokenId);
  }

  function _mint(address to, uint256 tokenId) internal override {
    super._mint(to, tokenId);

    _ownerID[to] = tokenId;
    _totalSupply++;
  }

  function _baseURI() internal view override returns (string memory) {
    return _URI;
  }
}
