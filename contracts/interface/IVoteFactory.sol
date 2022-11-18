// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IVoteFactory {
  event VoteCreated(uint256, uint256);

  function getViewAddress() external view returns (address);

  function getVoteCount(uint256) external view returns (uint256);

  function getVoteAddress(uint256, uint256) external view returns (address);

  function setViewAddress(address) external returns (address);

  function createVote(
    uint256,
    uint256,
    uint256,
    address
  ) external returns (address);

  function createVoteOptioned(
    uint256,
    uint256,
    uint256,
    address,
    uint8,
    bytes32[] calldata
  ) external returns (address);
}
