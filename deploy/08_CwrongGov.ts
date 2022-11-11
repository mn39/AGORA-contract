import { ViewAddress, CwrongNFTAddress } from "../scripts/01_ContractInfo";

const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractFactory("CwrongGov");
  const cwrongGov = await CwrongGov.deploy(0, "cWrong Governance", ViewAddress, CwrongNFTAddress);

  await cwrongGov.deployed();

  console.log("CwrongGov contract address:", cwrongGov.address);

  const buffer = fs.readFileSync("./deployedAddress.json");
  const data = buffer.toString();
  const dict = JSON.parse(data);

  dict.CwrongGov = cwrongGov.address;

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
