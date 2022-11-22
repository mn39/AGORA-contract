// SPDX-License-IDentifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IFunding.sol";

import "./interface/IView.sol";
import "./interface/IAgoraGov.sol";
import "./interface/IGovDatabase.sol";

contract Funding is IFunding {
  address private _viewAddress;
  bool private _initialized;
  uint256 private _govID;
  uint256 private _fundingID;
  uint256 private _created;
  uint256 private _deadline;
  uint256 private _fundingAmount;
  bool private _isEnable;
  string private _result;
  uint256 private _participants;
  uint256 private _for;
  uint256 private _against;
  uint256 private _abstain;
  mapping(address => string) private _voteList;
  address private _writer;

  modifier onlyMember() {
    address govDatabaseAddress = IView(_viewAddress).getGovDatabaseAddress();
    address govAddress = IGovDatabase(govDatabaseAddress).getGovAddress(_govID);

    require(IAgoraGov(govAddress).isGovMember(msg.sender), "Only member can vote.");
    _;
  }

  modifier onlyLeader() {
    require(msg.sender == _writer, "Only leader can finish");
    _;
  }

  function initialize(
    uint256 govID,
    uint256 fundingID,
    uint256 requiredTime,
    uint256 fundingAmount,
    address writer,
    address viewAddress
  ) external {
    _viewAddress = viewAddress;
    _initialized = true;
    _govID = govID;
    _fundingID = fundingID;
    _created = block.timestamp;
    _deadline = _created + requiredTime * 1 hours;

    _fundingAmount = fundingAmount;

    _isEnable = true;

    _participants = 0;

    _writer = writer;

    emit FundingStart(_created);
  }

  function getGovID() external view returns (uint256) {
    return _govID;
  }

  function getFundingID() external view returns (uint256) {
    return _fundingID;
  }

  function getCreated() external view returns (uint256) {
    return _created;
  }

  function getDeadline() external view returns (uint256) {
    return _deadline;
  }

  function getFundingAmount() external view returns (uint256) {
    return _fundingAmount;
  }

  function isEnable() external view returns (bool) {
    return _isEnable;
  }

  function getWriter() external view returns (address) {
    return _writer;
  }

  function isWriter(address addr) external view returns (bool) {
    if (addr == _writer) return true;
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

  function getParticipants() external view returns (uint256) {
    return _participants;
  }

  function voteOne(uint8 option) external onlyMember returns (bool) {
    require(option == 0 || option == 1 || option == 2, "Funding: Option is weird");
    require(_isEnable == true, "Funding is already finished");

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

  function fundingResult() external view returns (string memory) {
    require(_isEnable == false, "Funding is still Ongoing.");
    return _result;
  }

  function finish() external onlyLeader returns (bool) {
    require(_isEnable == true, "Funding is already finished");
    require(_isfinish() == false, "Funding is still Ongoing");

    _finish();

    emit FundingFinished(_result);

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
