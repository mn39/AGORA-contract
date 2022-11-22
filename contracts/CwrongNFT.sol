// SPDX-License-IDentifier: MIT

pragma solidity ^0.8.15;

import "./common/ERC721.sol";
import "./interface/IView.sol";
import "./interface/IAgoraNFT.sol";

import "./common/StringsUpgradeable.sol";

contract CwrongNFT is ERC721, IAgoraNFT {
  using StringsUpgradeable for uint256;

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
    if (addr == _leader) return 0;
    uint256 id = _ownerID[addr];

    require(id != 0, "You don't have NFT");
    return id;
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    string memory baseURI = _baseURI();
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI)) : "";
  }

  function setViewAddress(address newView) public onlyAdmin returns (address addr) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function setBaseURI(string memory baseURI) public onlyAdmin {
    _URI = baseURI;
  }

  function mint(address to, uint256 tokenID) public onlyAdmin {
    _safeMint(to, tokenID);
  }

  function _transfer(
    address from,
    address to,
    uint256 tokenID
  ) internal override isZeroID(tokenID) {
    require(_ownerID[to] == 0, "Receiver already have.");
    super._transfer(from, to, tokenID);
  }

  function _mint(address to, uint256 tokenID) internal override {
    super._mint(to, tokenID);

    _ownerID[to] = tokenID;
    _totalSupply++;
  }

  function _baseURI() internal view override returns (string memory) {
    return _URI;
  }
}
