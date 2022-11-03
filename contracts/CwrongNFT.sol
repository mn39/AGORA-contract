// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interface/IView.sol";

contract CwrongNFT is ERC721 {
  address internal _viewAddress;
  string private _URI;
  uint256 private _totalSupply;
  mapping(address => uint256) internal _ownerId;

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender) == true, "You are not admin");
    _;
  }

  modifier isZeroID(uint256 tokenId) {
    require(tokenId != 0, "Zero id token cannot be transfered");
    _;
  }

  constructor() ERC721("CwrongGov Test", "CWGT") {}

  function getViewAddress() public view returns (address) {
    return _viewAddress;
  }

  function totalSupply() public view returns (uint256 amount) {
    return _totalSupply;
  }

  function setViewAddress(address newView) public onlyAdmin returns (address) {
    _viewAddress = newView;
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
    require(_ownerId[to] == 0, "Receiver already have.");
    super._transfer(from, to, tokenId);
  }

  function _mint(address to, uint256 tokenId) internal override {
    super._mint(to, tokenId);

    _ownerId[to] = tokenId;
    _totalSupply++;
  }

  function _baseURI() internal view override returns (string memory) {
    return _URI;
  }
}
