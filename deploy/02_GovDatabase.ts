const hre = require("hardhat");
const fs = require("fs");
import { ViewAddress } from "../scripts/01_ContractInfo";

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const GovDatabase = await hre.ethers.getContractFactory("GovDatabase");
  const govDatabase = await GovDatabase.deploy(ViewAddress);

  await govDatabase.deployed();

  console.log("GovDatabase contract address:", govDatabase.address);

  const buffer = fs.readFileSync("./deployedAddress.json");
  const data = buffer.toString();
  const dict = JSON.parse(data);

  dict.GovDatabase = govDatabase.address;

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
