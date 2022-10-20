// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./CWrongNFT.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CwrongNFT is ERC721, Ownable, CWrongNFT {
  address private _viewAddress;
  uint256 private _govId;
  string private _name;
  address private _leader;
  uint256 private _voteCount;
  uint256 private _proposalCount;
  uint256 private _fundingCount;
  mapping(uint256 => address) private _voteAddresses;
  mapping(uint256 => address) private _proposalAddresses;
  mapping(uint256 => address) private _fundingAddresses;
  uint256 private _presentBalance;
  uint256 private _totalBalance;
  struct govRules {
    ;
  }

  constructor(
    address memory viewAddress, 
  uint256 memory govId, 
  string memory name, 
  address memory leader, 
  uint256 memory voteCount,
  uint256 memory proposalCount,
  uint256 memory fundingCount,
  uint256 memory presentBalance,
  uint256 memory totalBalance
  ) {
   _viewAddress = viewAddress;
   _govId =  govId;
   _name = name;
   _leader = leader;
   _voteCount = voteCount;
   _proposalCount = proposalCount;
   _fundingCount = fundingCount;
   _presentBalance = presentBalance;
   _totalBalance = totalBalance;
  }

  function getViewAddress() external view returns(address) {
    return _viewAddress;
  }

  function getGovId() external view returns(uint256) {
    return _govId;
  }

  function getGovName() external view returns(string) {
    return _name;
  }

  function getGovLeader() external view returns(address) {
    return _leader;
  }

  function isGovLeader(address addressId) external view returns(bool) {
    if(addressId == _leader) return true;

    return false;
  }

  function getMemberCount() external view returns(uint256) {
    
  }

  function isGovMember(address addressId) external view returns(bool) {

  }

  function getVoteCount() external view returns(uint256) {

  }

  function getProposalCount() external view returns(uint256) {
    return _proposalCount;
  }

  function getFundingCount() external view returns(uint256) {
    return _fundingCount;
  }

  function getVoteAddress(uint256 voteId) external view returns(address) {
    return _voteAddresses[voteId];
  }

  function getProposalAddress(uint256 proposalId) external view returns(address) {
    return _proposalAddresses[proposalId];
  }

  function getFundingAddress(uint256 fundingId) external view returns(address) {
    return _fundingAddresses[fundingId];
  }

  function getPresentBalance() external view returns(uint256) {
    return _presentBalance;
  }

  function getTotalBalance() external view returns(uint256) {
    return _totalBalance;
  }

  function setViewAddress(address newView) external view returns(address) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function setGovName(string name) external view returns(address) {
    
  }

  function createVote(uint256 gobId, uint256 voteId, uint256 requiredTime, uint8 optionCount, bytes32[] optionNames) external view returns(address) {

  }

  function createProposal() external view returns(address) {

  }

  function createFunding() external view returns(address) {

  }

  function VoteCreated(uint256 voteId) {

  }

  function ProposalCreated(uint256 proposalId) {

  }

  function FundingCreated(uint256 fundingId) {

  }

  function VoteResult(uint256 voteId, string result) {

  }

  function ProposalResult(uint256 proposalId, string result) {

  }

  function FundingResult(uint256 fundingId, string result) {

  }
}
