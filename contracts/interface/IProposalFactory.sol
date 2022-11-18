// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IProposalFactory {
  event ProposalCreated(uint256, uint256);

  function getViewAddress() external view returns (address);

  function getProposalCount(uint256) external view returns (uint256);

  function getProposalAddress(uint256, uint256) external view returns (address);

  function setViewAddress(address) external returns (address);

  function createProposal(
    uint256,
    uint256,
    uint256,
    address
  ) external returns (address);
}
