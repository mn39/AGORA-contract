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
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const GovDatabase = await hre.ethers.getContractAt("GovDatabase", GovDatabaseAddress, signer);
  const VoteFactory = await hre.ethers.getContractAt("VoteFactory", VoteFactoryAddress, signer);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, signer);
  const CwrongNFT = await hre.ethers.getContractAt("CwrongNFT", CwrongNFTAddress, signer);

  const tx1 = await GovDatabase.setViewAddress(ViewAddress);
  await tx1.wait();
  const tx2 = await VoteFactory.setViewAddress(ViewAddress);
  await tx2.wait();
  const tx3 = await AgoraToken.setViewAddress(ViewAddress);
  await tx3.wait();
  const tx4 = await CwrongNFT.setViewAddress(ViewAddress);
  await tx4.wait();

  console.log(await GovDatabase.getViewAddress());
  console.log(await VoteFactory.getViewAddress());
  console.log(await AgoraToken.getViewAddress());
  console.log(await CwrongNFT.getViewAddress());
}

main();
