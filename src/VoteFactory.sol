pragma solidity ^0.8.15;

import "./interface/IVoteFactory.sol";

import "./interface/IView.sol";
import "./interface/IVote.sol";
import "./Vote.sol";

contract VoteFactory is IVoteFactory {
  address private _viewAddress;
  mapping(uint256 => uint256) private _voteCount;
  mapping(uint256 => mapping(uint256 => address)) private _voteAddress;

  modifier onlyAdmin(address caller) {
    require(IView(_viewAddress).isAdmin(caller) == true, "You are not admin");
    _;
  }

  function getViewAddress() external view returns (address) {
    return _viewAddress;
  }

  function getVoteCount(uint256 govId) external view returns (uint256) {
    return _voteCount[govId];
  }

  function getVoteAdress(uint256 govId, uint256 voteId) external view returns (address) {
    return _voteAddress[govId][voteId];
  }

  function setViewAddress(address newView) external onlyAdmin(msg.sender) returns (address) {
    _viewAddress = newView;
  }

  function createVote(
    uint256 govId,
    uint256 voteId,
    uint256 requiredTime
  ) external returns (address) {
    require(_voteCount[govId] == voteId, "Invalid vote id");

    Vote vote = new Vote();
    vote.initialize(govId, voteId, requiredTime);

    _voteCount[govId]++;
    _voteAddress[govId][voteId] = address(vote);

    return address(vote);
  }

  function createVote(
    uint256 govId,
    uint256 voteId,
    uint256 requiredTime,
    uint8 optionCount,
    bytes32[] optionNames
  ) external returns (address) {
    require(_voteCount[govId] == voteId, "Invalid vote id");

    Vote vote = new Vote();
    vote.initialize(govId, voteId, requiredTime, optionCount, optionNames);

    _voteCount[govId]++;
    _voteAddress[govId][voteId] = address(vote);

    return address(vote);
  }
}
