pragma solidity ^0.8.15;

interface IVote {
  event VoteStart(uint256 created);
  event Vote(address, uint8 option, uint256 amount);
  event VoteFinished(string result);

  function initialize(
    uint256,
    uint256,
    uint256,
    address
  ) external;

  function initialize(
    uint256,
    uint256,
    uint256,
    uint8,
    bytes32[],
    address
  ) external;

  function getGovId() external view returns (uint256);

  function getVoteId() external view returns (uint256);

  function isOption() external view returns (bool);

  function isAuthor(address) external view returns (bool);

  function voteOne(uint8, uint256) external returns (bool);

  function voteResult() external view returns (string);
}
