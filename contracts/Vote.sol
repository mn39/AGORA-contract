// SPDX-License-IDentifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IVote.sol";

import "./interface/IView.sol";
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
    string _name;
    uint256 _stake;
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

    _optionStatus[0] = Option("for", 0);
    _optionStatus[1] = Option("against", 0);

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
      _optionStatus[i] = Option(optionName, 0);
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

  function voteOne(uint8 option, uint256 amount) external returns (bool) {
    require(msg.sender != _author, "Leader can't vote");

    _transferToken(amount);

    _perStake[option][msg.sender] += amount;
    _optionStatus[option]._stake += amount;
    _totalStake += amount;

    _renewResult();

    emit Vote(msg.sender, option, amount);

    return true;
  }

  function voteResult() external view returns (string memory) {
    return _optionStatus[_result]._name;
  }

  /* private function */

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
  }

  function _renewResult() private {
    uint8 winIndex;
    uint256 winStake = _optionStatus[_result]._stake;

    uint8 count = (_optionCount == 0) ? 2 : _optionCount;

    for (uint8 i = 0; i < count; i++) {
      uint256 stake = _optionStatus[i]._stake;
      if (stake > winStake) {
        winIndex = i;
        winStake = stake;
      }
    }

    _result = winIndex;
  }
}
