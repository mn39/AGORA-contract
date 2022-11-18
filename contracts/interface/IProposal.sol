// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IProposal {
  event ProposalStart(uint256 created);
  event Vote(address, string option);
  event ProposalFinished(string result);

  function initialize(
    uint256,
    uint256,
    uint256,
    address,
    address
  ) external;

  function getGovID() external view returns (uint256);

  function getProposalID() external view returns (uint256);

  function getCreated() external view returns (uint256);

  function getDeadline() external view returns (uint256);

  function isEnable() external view returns (bool);

  function getProposer() external view returns (address);

  function isProposer(address) external view returns (bool);

  function voteStatus()
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    );

  function voteOne(uint8) external returns (bool);

  function proposalResult() external view returns (string memory);

  function finish() external returns (bool);
}
