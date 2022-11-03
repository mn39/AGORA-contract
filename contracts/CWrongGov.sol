// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./CwrongNFT.sol";
import "./interface/IView.sol";
import "./interface/IVoteFactory.sol";
import "./interface/ICwrongGov.sol";

contract CwrongGov is CwrongNFT, ICwrongGov {
  uint256 private _govId;
  string private _govName;
  address private _leader;
  uint256 private _voteCount;
  uint256 private _proposalCount;
  uint256 private _fundingCount;
  mapping(uint256 => address) private _voteAddresses;
  mapping(uint256 => address) private _proposalAddresses;
  mapping(uint256 => address) private _fundingAddresses;
  uint256 private _presentBalance;
  uint256 private _totalBalance;

  modifier onlyLeader() {
    require(msg.sender == _leader, "You are not leader");
    _;
  }

  constructor(uint256 govId, string memory govName) {
    _govId = govId;
    _govName = govName;
    _leader = ownerOf(0);
    _voteCount = 0;
    _proposalCount = 0;
    _fundingCount = 0;
    _presentBalance = 0;
    _totalBalance = 0;
  }

  function getGovId() external view returns (uint256) {
    return _govId;
  }

  function getGovName() external view returns (string memory) {
    return _govName;
  }

  function getGovLeader() external view returns (address) {
    return _leader;
  }

  function isGovLeader(address addr) external view returns (bool) {
    if (addr == _leader) return true;

    return false;
  }

  function getMemberCount() external view returns (uint256) {
    return totalSupply();
  }

  function isGovMember(address addr) external view returns (bool) {
    return (_ownerId[addr] != 0) ? true : false;
  }

  function getVoteCount() external view returns (uint256) {
    return _voteCount;
  }

  function getProposalCount() external view returns (uint256) {
    return _proposalCount;
  }

  function getFundingCount() external view returns (uint256) {
    return _fundingCount;
  }

  function getVoteAddress(uint256 voteID) external view returns (address) {
    require(voteID < _voteCount, "Invalid voteID");
    return _voteAddresses[voteID];
  }

  function getProposalAddress(uint256 proposalID) external view returns (address) {
    require(proposalID < _proposalCount, "Invalid proposalID");
    return _proposalAddresses[proposalID];
  }

  function getFundingAddress(uint256 fundingID) external view returns (address) {
    require(fundingID < _fundingCount, "Invalid fundingID");
    return _fundingAddresses[fundingID];
  }

  function getPresentBalance() external view returns (uint256) {
    return _presentBalance;
  }

  function getTotalBalance() external view returns (uint256) {
    return _totalBalance;
  }

  function setGovName(string memory govName) external onlyLeader {
    _govName = govName;
  }

  function createVote(
    uint256 govId,
    uint256 voteID,
    uint256 requiredTime,
    address author
  ) external onlyLeader returns (address) {
    address voteFactory = IView(_viewAddress).getVoteFactoryAddress();
    address voteAddr = IVoteFactory(voteFactory).createVote(govId, voteID, requiredTime, author);

    emit VoteCreated(voteID);

    return voteAddr;
  }

  function createVote(
    uint256 govId,
    uint256 voteID,
    uint256 requiredTime,
    address author,
    uint8 optionCount,
    bytes32[] memory optionNames
  ) external onlyLeader returns (address) {
    address voteFactory = IView(_viewAddress).getVoteFactoryAddress();
    address voteAddr = IVoteFactory(voteFactory).createVote(
      govId,
      voteID,
      requiredTime,
      author,
      optionCount,
      optionNames
    );

    emit VoteCreated(voteID);

    return voteAddr;
  }

  function createProposal() external onlyLeader returns (address) {}

  function createFunding() external onlyLeader returns (address) {}
}
