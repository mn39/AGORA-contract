import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import {
  ViewAddress,
  GovDatabaseAddress,
  VoteFactoryAddress,
  AgoraTokenAddress,
  CwrongNFTAddress,
} from "./01_ContractInfo";

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const GovDatabase = await hre.ethers.getContractAt("GovDatabase", GovDatabaseAddress, deployer);
  const VoteFactory = await hre.ethers.getContractAt("VoteFactory", VoteFactoryAddress, deployer);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, deployer);
  const CwrongNFT = await hre.ethers.getContractAt("CwrongNFT", CwrongNFTAddress, deployer);

  await GovDatabase.setViewAddress(ViewAddress);
  await VoteFactory.setViewAddress(ViewAddress);
  await AgoraToken.setViewAddress(ViewAddress);
  await CwrongNFT.setViewAddress(ViewAddress);
}

main();
