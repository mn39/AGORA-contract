// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IGovDatabase.sol";
import "./interface/IView.sol";

contract GovDatabase is IGovDatabase {
  address private _viewAddress;

  struct Governance {
    address govAddress;
    address nftAddress;
    string govName;
  }

  mapping(uint256 => Governance) private _governances;
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

  function getGovAddress(uint256 govID) external view returns (address govAddress) {
    return _governances[govID].govAddress;
  }

  function getNFTAddress(uint256 govID) external view returns (address nftAddress) {
    return _governances[govID].nftAddress;
  }

  function getGovName(uint256 govID) external view returns (string memory govName) {
    return _governances[govID].govName;
  }

  function setViewAddress(address newView) external onlyAdmin returns (address) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function setNewGov(
    address govAddress,
    address nftAddress,
    string memory govName
  ) external onlyAdmin returns (uint256) {
    uint256 govID = _govCount;
    _governances[govID].govAddress = govAddress;
    _governances[govID].nftAddress = nftAddress;
    _governances[govID].govName = govName;

    emit GovInserted(govID, govAddress);

    _govCount++;

    return govID;
  }

  function updateGov(
    uint256 govID,
    address govAddress,
    address nftAddress,
    string memory govName
  ) external onlyAdmin returns (uint256) {
    _governances[govID].govAddress = govAddress;
    _governances[govID].nftAddress = nftAddress;
    _governances[govID].govName = govName;

    emit GovUpdated(govID, govAddress);

    return govID;
  }
}
