// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IFunding {
  event FundingStart(uint256 created);
  event Vote(address, string option);
  event FundingFinished(string result);

  function initialize(
    uint256,
    uint256,
    uint256,
    uint256,
    address,
    address
  ) external;

  function getGovID() external view returns (uint256);

  function getFundingID() external view returns (uint256);

  function getCreated() external view returns (uint256);

  function getDeadline() external view returns (uint256);

  function getFundingAmount() external view returns (uint256);

  function isEnable() external view returns (bool);

  function getWriter() external view returns (address);

  function isWriter(address) external view returns (bool);

  function voteStatus()
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    );

  function voteOne(uint8) external returns (bool);

  function fundingResult() external view returns (string memory);

  function finish() external returns (bool);
}
