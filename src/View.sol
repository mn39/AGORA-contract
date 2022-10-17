pragma solidity ^0.8.15;

import "./interface/IView.sol";

contract View is IView {
  address private _admin;
  address private _tokenAddress;
  address private _voteFactoryAddress;
  address private _proposalFactoryAddress;
  address private _fundingFactoryAddress;
  address private _govDatabaseAddress;

  modifier onlyAdmin() {
    require(msg.sender == _admin, "You are not admin");
    _;
  }

  constructor() {
    _admin = msg.sender;
  }

  function getAdmin() external view returns (address) {
    return _admin;
  }

  function isAdmin(address caller) external view returns (bool) {
    return (caller == _admin);
  }

  function getTokenAddress() external view returns (address) {
    return _tokenAddress;
  }

  function getVoteFactoryAddress() external view returns (address) {
    return _voteFactoryAddress;
  }

  function getProposalFactoryAddress() external view returns (address) {
    return _proposalFactoryAddress;
  }

  function getFundingFactoryAddress() external view returns (address) {
    return _fundingFactoryAddress;
  }

  function getGovDatabaseAddress() external view returns (address) {
    return _govDatabaseAddress;
  }

  function setTokenAddress(address newAddress) external onlyAdmin {
    _tokenAddress = newAddress;
  }

  function setVoteFactoryAddress(address newAddress) external onlyAdmin {
    _voteFactoryAddress = newAddress;
  }

  function setProposalFactoryAddress(address newAddress) external onlyAdmin {
    _proposalFactoryAddress = newAddress;
  }

  function setFundingFactoryAddress(address newAddress) external onlyAdmin {
    _fundingFactoryAddress = newAddress;
  }

  function setGovDatabaseAddress(address newAddress) external onlyAdmin {
    _govDatabaseAddress = newAddress;
  }
}
