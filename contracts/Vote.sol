// SPDX-License-IDentifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IVote.sol";

import "./interface/IView.sol";
import "./interface/IGovDatabase.sol";
import "./interface/IAgoraGov.sol";
import "./AgoraToken.sol";

contract Vote is IVote {
  bool private _initialized;

  address private _viewAddress;

  uint256 private _govID;
  uint256 private _voteID;
  uint256 private _created;
  uint256 private _deadline;

  bool private _isEnable;
  uint8 private _result;

  address private _author;

  uint256 private _totalStake;

  uint8 private _optionCount;

  struct Option {
    string name;
    uint256 stake;
    address[] voteList;
  }

  mapping(uint8 => mapping(address => uint256)) private _perStake;

  mapping(uint8 => Option) private _optionStatus;

  function initialize(
    uint256 govID,
    uint256 voteID,
    uint256 requiredTime,
    address author,
    address viewAddress
  ) public {
    require(_initialized == false, "already initialized");
    _initialized = true;

    _viewAddress = viewAddress;

    _govID = govID;
    _voteID = voteID;
    _created = block.timestamp;
    _deadline = _created + requiredTime * 1 hours;

    _isEnable = true;
    _result = 0;

    _author = author;

    _totalStake = 0;

    _optionCount = 0;

    _optionStatus[0] = Option("for", 0, new address[](0));
    _optionStatus[1] = Option("against", 0, new address[](0));

    emit VoteStart(_created);
  }

  function initializeOptioned(
    uint256 govID,
    uint256 voteID,
    uint256 requiredTime,
    address author,
    uint8 optionCount,
    bytes32[] calldata optionNames,
    address viewAddress
  ) public {
    require(_initialized == false, "already initialized");
    _initialized = true;

    _viewAddress = viewAddress;

    _govID = govID;
    _voteID = voteID;
    _created = block.timestamp;
    _deadline = _created + requiredTime * 1 hours;

    _isEnable = true;
    _result = 0;

    _author = author;

    _totalStake = 0;

    _optionCount = optionCount;
    for (uint8 i = 0; i < optionCount; i++) {
      string memory optionName = _bytes32ToString(optionNames[i]);
      _optionStatus[i] = Option(optionName, 0, new address[](0));
    }

    emit VoteStart(_created);
  }

  function getGovID() external view returns (uint256) {
    return _govID;
  }

  function getVoteID() external view returns (uint256) {
    return _voteID;
  }

  function getCreated() external view returns (uint256) {
    return _created;
  }

  function getDeadline() external view returns (uint256) {
    return _deadline;
  }

  function isOption() external view returns (bool) {
    return (_optionCount != 0);
  }

  function isAuthor(address caller) external view returns (bool) {
    return (caller == _author);
  }

  function voteStatus()
    external
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    require(_isEnable == true, "Vote is finished");

    uint256 t1 = _optionStatus[0].stake;
    uint256 t2 = _optionStatus[1].stake;
    uint256 t3 = (_optionCount < 3) ? 0 : _optionStatus[2].stake;
    uint256 t4 = (_optionCount < 4) ? 0 : _optionStatus[3].stake;

    return (t1, t2, t3, t4);
  }

  function voteOne(uint8 option, uint256 amount) external returns (bool) {
    require(msg.sender != _author, "Leader can't vote");
    require(_isEnable == true, "Vote is finished");

    _transferToken(amount);

    _perStake[option][msg.sender] += amount;
    _optionStatus[option].stake += amount;
    _optionStatus[option].voteList.push(msg.sender);

    _resetResult();

    emit Vote(msg.sender, _optionStatus[option].name, amount);

    return true;
  }

  function voteResult() external view returns (string memory) {
    require(_isEnable == false, "Vote is still ongoing");

    return _optionStatus[_result].name;
  }

  function finish() external returns (bool) {
    require(_isEnable == true, "Vote is already finished");
    require(_isfinish() == false, "Vote is still Ongoing");
    require(msg.sender == _author, "Only leader can finish vote");

    _finish();

    emit VoteFinished(_optionStatus[_result].name);

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

    _payback();
  }

  function _bytes32ToString(bytes32 _bytes32) private pure returns (string memory) {
    uint8 i = 0;
    while (i < 32 && _bytes32[i] != 0) {
      i++;
    }
    bytes memory bytesArray = new bytes(i);
    for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
      bytesArray[i] = _bytes32[i];
    }
    return string(bytesArray);
  }

  function _transferToken(uint256 amount) private {
    address agoraTokenAddress = IView(_viewAddress).getTokenAddress();
    AgoraToken(agoraTokenAddress).transferVote(address(this), amount);

    _totalStake += amount;
  }

  function _resetResult() private {
    uint8 winIndex;
    uint256 winStake = _optionStatus[_result].stake;

    uint8 count = (_optionCount == 0) ? 2 : _optionCount;

    for (uint8 i = 0; i < count; i++) {
      uint256 stake = _optionStatus[i].stake;
      if (stake > winStake) {
        winIndex = i;
        winStake = stake;
      }
    }

    _result = winIndex;
  }

  function _payback() private {
    address agoraTokenAddress = IView(_viewAddress).getTokenAddress();

    uint8 count = (_optionCount == 0) ? 2 : _optionCount;

    for (uint8 i = 0; i < count; i++) {
      if (i == _result) continue;
      uint256 len = _optionStatus[i].voteList.length;

      for (uint256 j = 0; j < len; j++) {
        address voter = _optionStatus[i].voteList[j];
        uint256 amount = _perStake[i][voter];

        AgoraToken(agoraTokenAddress).transfer(voter, amount);
      }
    }

    _totalStake = _optionStatus[_result].stake;

    address govDatabaseAddress = IView(_viewAddress).getGovDatabaseAddress();
    address govAddress = IGovDatabase(govDatabaseAddress).getGovAddress(_govID);
    AgoraToken(agoraTokenAddress).transfer(govAddress, _totalStake);
  }
}
