// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IFundingFactory {
  event FundingCreated(uint256, uint256);

  function getViewAddress() external view returns (address);

  function getFundingCount(uint256) external view returns (uint256);

  function getFundingAddress(uint256, uint256) external view returns (address);

  function setViewAddress(address) external returns (address);

  function createFunding(
    uint256,
    uint256,
    uint256,
    uint256,
    address
  ) external returns (address);
}
