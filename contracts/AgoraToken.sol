// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "./common/ERC20.sol";
import "./interface/IView.sol";

contract AgoraToken is ERC20 {
  address private _viewAddress;
  uint256 public INITIAL_SUPPLY = 10000;

  modifier onlyAdmin() {
    require(IView(_viewAddress).isAdmin(msg.sender) == true, "You are not admin");
    _;
  }

  constructor() ERC20("AgoraTokenTest", "AGTT") {
    _mint(msg.sender, INITIAL_SUPPLY);
  }

  function decimals() public pure override returns (uint8) {
    return 0;
  }

  function getViewAddress() external view returns (address) {
    return _viewAddress;
  }

  function setViewAddress(address newView) external onlyAdmin returns (address) {
    _viewAddress = newView;
  }
}
