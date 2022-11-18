// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IVoteFactory.sol";

import "./interface/IView.sol";
import "./interface/IVote.sol";
import "./Vote.sol";

contract VoteFactory is IVoteFactory {
  address private _viewAddress;
  mapping(uint256 => uint256) private _voteCount;
  mapping(uint256 => mapping(uint256 => address)) private _voteAddress;

  constructor(address viewAddress) {
    _viewAddress = viewAddress;
  }

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender) == true, "You are not admin");
    _;
  }

  function getViewAddress() external view returns (address addr) {
    return _viewAddress;
  }

  function getVoteCount(uint256 govID) external view returns (uint256 count) {
    return _voteCount[govID];
  }

  function getVoteAddress(uint256 govID, uint256 voteID) external view returns (address addr) {
    return _voteAddress[govID][voteID];
  }

  function setViewAddress(address newView) external onlyAdmin returns (address addr) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function createVote(
    uint256 govID,
    uint256 voteID,
    uint256 requiredTime,
    address author
  ) external returns (address addr) {
    require(_voteCount[govID] == voteID, "Invalid vote id");

    Vote vote = new Vote();
    vote.initialize(govID, voteID, requiredTime, author, _viewAddress);

    _voteCount[govID]++;
    _voteAddress[govID][voteID] = address(vote);

    emit VoteCreated(govID, voteID);

    return address(vote);
  }

  function createVoteOptioned(
    uint256 govID,
    uint256 voteID,
    uint256 requiredTime,
    address author,
    uint8 optionCount,
    bytes32[] memory optionNames
  ) external returns (address addr) {
    require(_voteCount[govID] == voteID, "Invalid vote id");

    Vote vote = new Vote();
    vote.initializeOptioned(govID, voteID, requiredTime, author, optionCount, optionNames, _viewAddress);

    _voteCount[govID]++;
    _voteAddress[govID][voteID] = address(vote);

    emit VoteCreated(govID, voteID);

    return address(vote);
  }
}
