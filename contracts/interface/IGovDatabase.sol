// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IGovDatabase {
  event GovInserted(uint256 govId, address govAddress);
  event GovUpdated(uint256 govID, address govAddress);

  function getViewAddress() external view returns (address);

  function getGovCount() external view returns (uint256);

  function getGovAddress(uint256) external view returns (address);

  function getNFTAddress(uint256) external view returns (address);

  function getGovName(uint256) external view returns (string memory);

  function setViewAddress(address) external returns (address);

  function setNewGov(
    address,
    address,
    string memory
  ) external returns (uint256);

  function updateGov(
    uint256,
    address,
    address,
    string memory
  ) external returns (uint256);
}
