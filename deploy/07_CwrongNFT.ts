const hre = require("hardhat");
const fs = require("fs");
import { ViewAddress } from "../scripts/01_ContractInfo";

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const CwrongNFT = await hre.ethers.getContractFactory("CwrongNFT");
  const cwrongNFT = await CwrongNFT.deploy(ViewAddress, deployer.address);

  await cwrongNFT.deployed();

  console.log("CwrongNFT contract address:", cwrongNFT.address);

  const buffer = fs.readFileSync("./deployedAddress.json");
  const data = buffer.toString();
  const dict = JSON.parse(data);

  dict.CwrongNFT = cwrongNFT.address;

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
