// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IGovDatabase {
  event GovInserted(uint256 govId, address govAddress);

  function getViewAddress() external view returns (address);

  function getGovCount() external view returns (uint256 govCount);

  function getGovAddress(uint256 govIndex) external view returns (address govAddress);

  function setViewAddress(address newView) external returns (address);

  function setNewGov(address) external returns (uint256);
}
