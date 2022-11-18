// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

import "./interface/IProposalFactory.sol";

import "./interface/IView.sol";
import "./interface/IGovDatabase.sol";
import "./interface/IProposalFactory.sol";
import "./interface/IAgoraGov.sol";
import "./interface/IProposal.sol";

import "./Proposal.sol";

contract ProposalFactory is IProposalFactory {
  address private _viewAddress;
  mapping(uint256 => uint256) private _proposalCount;
  mapping(uint256 => mapping(uint256 => address)) private _proposalAddress;

  constructor(address viewAddress) {
    _viewAddress = viewAddress;
  }

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender) == true, "You are not admin");
    _;
  }

  modifier onlyLeaderOrMember(uint256 govID, address proposer) {
    address govDatabaseAddress = IView(_viewAddress).getGovDatabaseAddress();
    address govAddress = IGovDatabase(govDatabaseAddress).getGovAddress(govID);

    require(
      IAgoraGov(govAddress).isGovLeader(proposer) || IAgoraGov(govAddress).isGovMember(proposer),
      "Only leader or member can make proposal"
    );
    _;
  }

  function getViewAddress() external view returns (address addr) {
    return _viewAddress;
  }

  function getProposalCount(uint256 govID) external view returns (uint256 count) {
    return _proposalCount[govID];
  }

  function getProposalAddress(uint256 govID, uint256 proposalID) external view returns (address addr) {
    return _proposalAddress[govID][proposalID];
  }

  function setViewAddress(address newView) external onlyAdmin returns (address addr) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function createProposal(
    uint256 govID,
    uint256 proposalID,
    uint256 requiredTime,
    address proposer
  ) external onlyLeaderOrMember(govID, proposer) returns (address addr) {
    require(_proposalCount[govID] == proposalID, "Invalid proposal id");

    Proposal proposal = new Proposal();
    proposal.initialize(govID, proposalID, requiredTime, proposer, _viewAddress);

    _proposalCount[govID]++;
    _proposalAddress[govID][proposalID] = address(proposal);

    emit ProposalCreated(govID, proposalID);

    return address(proposal);
  }
}
