// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

interface IAgoraNFT {
  function getViewAddress() external view returns (address);

  function totalSupply() external view returns (uint256);

  function ownerID(address addr) external view returns (uint256);

  function setViewAddress(address) external returns (address);

  function setBaseURI(string memory) external;

  function mint(address, uint256) external;
}
