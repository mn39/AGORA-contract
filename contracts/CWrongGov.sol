// SPDX-License-IDentifier: MIT

pragma solidity ^0.8.15;

import "./interface/IView.sol";
import "./interface/IVoteFactory.sol";
import "./interface/IProposalFactory.sol";
import "./interface/IFundingFactory.sol";
import "./interface/IAgoraGov.sol";
import "./AgoraToken.sol";
import "./CwrongNFT.sol";

contract CwrongGov is IAgoraGov {
  address private _viewAddress;
  address private _nftAddress;
  uint256 private _govID;
  string private _govName;
  address private _leader;
  uint256 private _voteCount;
  uint256 private _proposalCount;
  uint256 private _fundingCount;
  mapping(uint256 => address) private _voteAddresses;
  mapping(uint256 => address) private _proposalAddresses;
  mapping(uint256 => address) private _fundingAddresses;
  uint256 private _usedTokenAmount;

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender) == true, "You are not admin");
    _;
  }

  modifier onlyLeader() {
    require(msg.sender == _leader, "You are not leader");
    _;
  }

  modifier onlyLeaderOrMember() {
    require(msg.sender == _leader || CwrongNFT(_nftAddress).ownerID(msg.sender) > 0, "You are not leader");
    _;
  }

  constructor(
    uint256 govID,
    string memory govName,
    address viewAddress,
    address nftAddress
  ) {
    _viewAddress = viewAddress;
    _nftAddress = nftAddress;
    _govID = govID;
    _govName = govName;
    _leader = CwrongNFT(nftAddress).ownerOf(0);
    _voteCount = 0;
    _proposalCount = 0;
    _fundingCount = 0;
    _usedTokenAmount = 0;
  }

  function getViewAddress() public view returns (address addr) {
    return _viewAddress;
  }

  function getGovID() external view returns (uint256) {
    return _govID;
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
    return CwrongNFT(_nftAddress).totalSupply();
  }

  function isGovMember(address addr) external view returns (bool) {
    return (CwrongNFT(_nftAddress).ownerID(addr) > 0) ? true : false;
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
    require(voteID < _voteCount, "[CwrongGov] Invalid voteID");
    return _voteAddresses[voteID];
  }

  function getProposalAddress(uint256 proposalID) external view returns (address) {
    require(proposalID < _proposalCount, "[CwrongGov] Invalid proposalID");
    return _proposalAddresses[proposalID];
  }

  function getFundingAddress(uint256 fundingID) external view returns (address) {
    require(fundingID < _fundingCount, "[CwrongGov] Invalid fundingID");
    return _fundingAddresses[fundingID];
  }

  function getPresentBalance() external view returns (uint256) {
    address agoraToken = IView(_viewAddress).getTokenAddress();
    uint256 balance = AgoraToken(agoraToken).balanceOf(address(this));
    return balance;
  }

  function getTotalBalance() external view returns (uint256) {
    address agoraToken = IView(_viewAddress).getTokenAddress();
    uint256 balance = AgoraToken(agoraToken).balanceOf(address(this));
    return balance + _usedTokenAmount;
  }

  function tokenWithdraw(address addr, uint256 amount) external returns (bool) {
    address agoraToken = IView(_viewAddress).getTokenAddress();

    _usedTokenAmount += amount;

    AgoraToken(agoraToken).transfer(addr, amount);

    return true;
  }

  function setViewAddress(address newView) public onlyAdmin returns (address addr) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function setGovName(string memory govName) external onlyLeader {
    _govName = govName;
  }

  function createVote(uint256 requiredTime) external onlyLeader returns (address) {
    uint256 voteID = _voteCount;

    address voteFactory = IView(_viewAddress).getVoteFactoryAddress();
    address voteAddr = IVoteFactory(voteFactory).createVote(_govID, voteID, requiredTime, msg.sender);

    _voteAddresses[voteID] = voteAddr;
    _voteCount++;

    emit VoteCreated(voteID);

    return voteAddr;
  }

  function createVoteOptioned(
    uint256 requiredTime,
    uint8 optionCount,
    bytes32[] memory optionNames
  ) external onlyLeader returns (address) {
    uint256 voteID = _voteCount;

    address voteFactory = IView(_viewAddress).getVoteFactoryAddress();
    address voteAddr = IVoteFactory(voteFactory).createVoteOptioned(
      _govID,
      voteID,
      requiredTime,
      msg.sender,
      optionCount,
      optionNames
    );

    _voteAddresses[voteID] = voteAddr;
    _voteCount++;

    emit VoteCreated(voteID);

    return voteAddr;
  }

  function createProposal(uint256 requiredTime) external onlyLeaderOrMember returns (address) {
    uint256 proposalID = _proposalCount;

    address proposalFactory = IView(_viewAddress).getProposalFactoryAddress();
    address proposalAddr = IProposalFactory(proposalFactory).createProposal(
      _govID,
      proposalID,
      requiredTime,
      msg.sender
    );

    _proposalAddresses[proposalID] = proposalAddr;
    _proposalCount++;

    emit ProposalCreated(proposalID);

    return proposalAddr;
  }

  function createFunding(uint256 requiredTime, uint256 fundingAmount) external onlyLeader returns (address) {
    uint256 fundingID = _fundingCount;

    address fundingFactory = IView(_viewAddress).getFundingFactoryAddress();
    address fundingAddr = IFundingFactory(fundingFactory).createFunding(
      _govID,
      fundingID,
      requiredTime,
      fundingAmount,
      msg.sender
    );

    _fundingAddresses[fundingID] = fundingAddr;
    _fundingCount++;

    emit FundingCreated(fundingID);

    return fundingAddr;
  }
}
