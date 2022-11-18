// SPDX-License-IDentifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IProposal.sol";

import "./interface/IView.sol";
import "./interface/IAgoraGov.sol";
import "./interface/IGovDatabase.sol";

contract Proposal is IProposal {
  address private _viewAddress;
  bool private _initialized;
  uint256 private _govID;
  uint256 private _proposalID;
  uint256 private _created;
  uint256 private _deadline;
  bool private _isEnable;
  string private _result;
  uint256 private _participants;
  uint256 private _for;
  uint256 private _against;
  uint256 private _abstain;
  mapping(address => string) private _voteList;
  address private _proposer;

  modifier notProposer() {
    require(msg.sender != _proposer, "Proposer can't Vote");
    _;
  }

  modifier onlyProposer() {
    require(msg.sender == _proposer, "Only proposer can finish");
    _;
  }

  modifier onlyMember() {
    address govDatabaseAddress = IView(_viewAddress).getGovDatabaseAddress();
    address govAddress = IGovDatabase(govDatabaseAddress).getGovAddress(_govID);

    require(IAgoraGov(govAddress).isGovMember(msg.sender), "Only member can vote.");
    _;
  }

  function initialize(
    uint256 govID,
    uint256 proposalID,
    uint256 requiredTime,
    address proposer,
    address viewAddress
  ) external {
    _viewAddress = viewAddress;
    _initialized = true;
    _govID = govID;
    _proposalID = proposalID;
    _created = block.timestamp;
    _deadline = _created + requiredTime * 1 hours;

    _isEnable = true;

    _participants = 0;
    _proposer = proposer;

    emit ProposalStart(_created);
  }

  function getGovID() external view returns (uint256) {
    return _govID;
  }

  function getProposalID() external view returns (uint256) {
    return _proposalID;
  }

  function getCreated() external view returns (uint256) {
    return _created;
  }

  function getDeadline() external view returns (uint256) {
    return _deadline;
  }

  function isEnable() external view returns (bool) {
    return _isEnable;
  }

  function getProposer() external view returns (address) {
    return _proposer;
  }

  function isProposer(address addr) external view returns (bool) {
    if (addr == _proposer) return true;
    return false;
  }

  function voteStatus()
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    require(_isEnable == true, "Proposal is finished");

    return (_for, _against, _abstain);
  }

  function voteOne(uint8 option) external notProposer onlyMember returns (bool) {
    require(option == 0 || option == 1 || option == 2, "Proposal: Option is weird");
    require(_isEnable == true, "Proposal is already finished");

    if (option == 0) {
      _for++;
      _voteList[msg.sender] = "for";

      emit Vote(msg.sender, "for");
    } else if (option == 1) {
      _against++;
      _voteList[msg.sender] = "against";

      emit Vote(msg.sender, "against");
    } else {
      _abstain++;
      _voteList[msg.sender] = "abstain";

      emit Vote(msg.sender, "abstain");
    }

    _resetResult();

    return true;
  }

  function proposalResult() external view returns (string memory) {
    require(_isEnable == false, "Proposal is still Ongoing.");
    return _result;
  }

  function finish() external onlyProposer returns (bool) {
    require(_isEnable == true, "Proposal is already finished");
    require(_isfinish() == false, "Proposal is still Ongoing");

    _finish();

    emit ProposalFinished(_result);

    return true;
  }

  /* private function */

  function _isfinish() private view returns (bool) {
    if (block.timestamp > _deadline) return true;
    return false;
  }

  function _finish() private {
    _isEnable = false;

    _resetResult();
  }

  function _resetResult() private {
    if (_for >= _against) {
      _result = "for";
    } else {
      _result = "against";
    }
  }
}
