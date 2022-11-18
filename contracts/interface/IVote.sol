// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IVote {
  event VoteStart(uint256 created);
  event Vote(address, string option, uint256 amount);
  event VoteFinished(string result);

  function initialize(
    uint256,
    uint256,
    uint256,
    address,
    address
  ) external;

  function initializeOptioned(
    uint256,
    uint256,
    uint256,
    address,
    uint8,
    bytes32[] calldata,
    address
  ) external;

  function getGovID() external view returns (uint256);

  function getVoteID() external view returns (uint256);

  function getCreated() external view returns (uint256);

  function getDeadline() external view returns (uint256);

  function isOption() external view returns (bool);

  function isAuthor(address) external view returns (bool);

  function voteStatus()
    external
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256
    );

  function voteOne(uint8, uint256) external returns (bool);

  function voteResult() external view returns (string memory);

  function finish() external returns (bool);
}
