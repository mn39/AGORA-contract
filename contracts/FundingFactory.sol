// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IFundingFactory.sol";

import "./interface/IView.sol";
import "./interface/IGovDatabase.sol";
import "./interface/IFundingFactory.sol";
import "./interface/IAgoraGov.sol";
import "./interface/IFunding.sol";

import "./Funding.sol";

contract FundingFactory is IFundingFactory {
  address private _viewAddress;
  mapping(uint256 => uint256) private _fundingCount;
  mapping(uint256 => mapping(uint256 => address)) private _fundingAddress;

  constructor(address viewAddress) {
    _viewAddress = viewAddress;
  }

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender) == true, "You are not admin");
    _;
  }

  modifier onlyLeader(uint256 govID, address writer) {
    address govDatabaseAddress = IView(_viewAddress).getGovDatabaseAddress();
    address govAddress = IGovDatabase(govDatabaseAddress).getGovAddress(govID);

    require(IAgoraGov(govAddress).isGovLeader(writer), "Only leader can make funding");
    _;
  }

  function getViewAddress() external view returns (address addr) {
    return _viewAddress;
  }

  function getFundingCount(uint256 govID) external view returns (uint256 count) {
    return _fundingCount[govID];
  }

  function getFundingAddress(uint256 govID, uint256 fundingID) external view returns (address addr) {
    return _fundingAddress[govID][fundingID];
  }

  function setViewAddress(address newView) external onlyAdmin returns (address addr) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function createFunding(
    uint256 govID,
    uint256 fundingID,
    uint256 requiredTime,
    uint256 fundingAmount,
    address writer
  ) external onlyLeader(govID, writer) returns (address addr) {
    require(_fundingCount[govID] == fundingID, "Invalid funding id");

    Funding funding = new Funding();
    funding.initialize(govID, fundingID, requiredTime, fundingAmount, writer, _viewAddress);

    _fundingCount[govID]++;
    _fundingAddress[govID][fundingID] = address(funding);

    emit FundingCreated(govID, fundingID);

    return address(funding);
  }
}
