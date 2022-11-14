pragma solidity ^0.8.15;

import "hardhat/console.sol";

contract test {
  mapping(uint256 => uint256) map;
  uint256 private mapCount;

  function getmap(uint256 id) public view returns (uint256) {
    return map[id];
  }

  function setmap(uint256 id, uint256 value) public {
    console.log(id);
    console.log(mapCount);
    console.log(map[mapCount]);

    require(id == map[mapCount], "id already sets");

    map[id] = value;
    mapCount++;
  }
}
