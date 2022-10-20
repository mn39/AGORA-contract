// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.15;

import "./common/ERC20.sol";

contract AgoraToken is ERC20 {
  uint256 public INITIAL_SUPPLY = 10000;

  constructor() ERC20("AgoraTokenTest", "AGTT") {
    _mint(msg.sender, INITIAL_SUPPLY);
  }

  function decimals() public pure override returns (uint8) {
    return 0;
  }
}
