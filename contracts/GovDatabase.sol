// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IGovDatabase.sol";

import "./interface/IView.sol";

contract GovDatabase is IGovDatabase {
  address private _viewAddress;
  mapping(uint256 => address) private _govAddresses;
  uint256 private _govCount;

  constructor(address viewAddress) {
    _viewAddress = viewAddress;
  }

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender), "You are not admin");
    _;
  }

  function getViewAddress() external view returns (address) {
    return _viewAddress;
  }

  function getGovCount() external view returns (uint256) {
    return _govCount;
  }

  function getGovAddress(uint256 govIndex) external view returns (address govAddress) {
    return _govAddresses[govIndex];
  }

  function setViewAddress(address newView) external onlyAdmin {
    _viewAddress = newView;
  }

  function setNewGov(address govAddress) external onlyAdmin returns (uint256) {
    _govAddresses[_govCount] = govAddress;
    _govCount++;
    return _govCount - 1;
  }
}
