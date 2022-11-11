// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface ICwrongGov {
  event VoteCreated(uint256 voteID);
  event ProposalCreated(uint256 proposalID);
  event FundingCreated(uint256 fundingID);
  event VoteResult(uint256 voteID, string result);
  event ProposalResult(uint256 proposalID, string result);
  event FundingResult(uint256 fundingID, string result);

  function getGovId() external view returns (uint256);

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

  function setGovName(string calldata) external;

  function createVote(
    uint256 govId,
    uint256 voteID,
    uint256 requiredTime,
    address author
  ) external returns (address);

  function createVote(
    uint256 govId,
    uint256 voteID,
    uint256 requiredTime,
    address author,
    uint8 optionCount,
    bytes32[] calldata
  ) external returns (address);

  function createProposal() external returns (address);

  function createFunding() external returns (address);
}
