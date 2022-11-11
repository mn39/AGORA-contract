const hre = require("hardhat");
const fs = require("fs");
import { ViewAddress } from "../scripts/01_ContractInfo";

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const VoteFactory = await hre.ethers.getContractFactory("VoteFactory");
  const voteFactory = await VoteFactory.deploy(ViewAddress);

  await voteFactory.deployed();

  console.log("VoteFactory contract address:", voteFactory.address);

  const buffer = fs.readFileSync("./deployedAddress.json");
  const data = buffer.toString();
  const dict = JSON.parse(data);

  dict.VoteFactory = voteFactory.address;

  const dictJSON = JSON.stringify(dict);
  fs.writeFileSync("./deployedAddress.json", dictJSON);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

module.exports = main;
