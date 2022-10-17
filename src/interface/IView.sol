pragma solidity ^0.8.15;

interface IView {
  event TokenChanged(address, address);
  event VoteFactoryChanged(address, address);
  event ProposalFactoryChanged(address, address);
  event FundingFactoryChanged(address, address);
  event GovDatabaseChanged(address, address);

  function getAdmin() external view returns (address);

  function isAdmin(address) external view returns (bool);

  function getTokenAddress() external view returns (address);

  function getVoteFactoryAddress() external view returns (address);

  function getProposalFactoryAddress() external view returns (address);

  function getFundingFactoryAddress() external view returns (address);

  function getGovDatabaseAddress() external view returns (address);

  function setTokenAddress(address) external;

  function setVoteFactoryAddress(address) external;

  function setProposalFactoryAddress(address) external;

  function setFundingFactoryAddress(address) external;

  function setGovDatabaseAddress(address) external;
}
