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

  constructor(address viewAddress) ERC20("AgoraTokenTest", "AGTT") {
    _mint(msg.sender, INITIAL_SUPPLY);
    _viewAddress = viewAddress;
  }

  function decimals() public pure override returns (uint8 deci) {
    return 0;
  }

  function getViewAddress() external view returns (address addr) {
    return _viewAddress;
  }

  function setViewAddress(address newView) external onlyAdmin returns (address newAddress) {
    _viewAddress = newView;
    return _viewAddress;
  }

  function transferVote(address to, uint256 amount) public returns (bool) {
    address owner = tx.origin;
    _transfer(owner, to, amount);
    return true;
  }
}
