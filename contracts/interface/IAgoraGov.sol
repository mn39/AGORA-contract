// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IAgoraGov {
  event VoteCreated(uint256 voteID);
  event ProposalCreated(uint256 proposalID);
  event FundingCreated(uint256 fundingID);
  event VoteResult(uint256 voteID, string result);
  event ProposalResult(uint256 proposalID, string result);
  event FundingResult(uint256 fundingID, string result);

  function getViewAddress() external view returns (address);

  function getGovID() external view returns (uint256);

  function getGovName() external view returns (string memory);

  function getGovLeader() external view returns (address);

  function isGovLeader(address addr) external view returns (bool);

  function getMemberCount() external view returns (uint256);

  function isGovMember(address addr) external view returns (bool);

  function getVoteCount() external view returns (uint256);

  function getProposalCount() external view returns (uint256);

  function getFundingCount() external view returns (uint256);

  function getVoteAddress(uint256 voteID) external view returns (address);

  function getProposalAddress(uint256 proposalID) external view returns (address);

  function getFundingAddress(uint256 fundingID) external view returns (address);

  function getPresentBalance() external view returns (uint256);

  function getTotalBalance() external view returns (uint256);

  function tokenWithdraw(address addr, uint256 amount) external returns (bool);

  function setViewAddress(address newView) external returns (address);

  function setGovName(string calldata) external;

  function createVote(uint256 requiredTime) external returns (address);

  function createVoteOptioned(
    uint256 requiredTime,
    uint8 optionCount,
    bytes32[] calldata
  ) external returns (address);

  function createProposal(uint256 requiredTime) external returns (address);

  function createFunding(uint256 requiredTime, uint256 fundingAmount) external returns (address);
}
