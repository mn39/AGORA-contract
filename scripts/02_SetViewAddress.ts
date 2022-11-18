import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import {
  ViewAddress,
  GovDatabaseAddress,
  VoteFactoryAddress,
  ProposalFactoryAddress,
  FundingFactoryAddress,
  AgoraTokenAddress,
  CwrongNFTAddress,
  CwrongGovAddress,
} from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const GovDatabase = await hre.ethers.getContractAt("GovDatabase", GovDatabaseAddress, signer);
  const VoteFactory = await hre.ethers.getContractAt("VoteFactory", VoteFactoryAddress, signer);
  const ProposalFactory = await hre.ethers.getContractAt("ProposalFactory", ProposalFactoryAddress, signer);
  const FundingFactory = await hre.ethers.getContractAt("FundingFactory", FundingFactoryAddress, signer);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, signer);
  const CwrongNFT = await hre.ethers.getContractAt("CwrongNFT", CwrongNFTAddress, signer);
  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, signer);

  const tx1 = await GovDatabase.setViewAddress(ViewAddress);
  await tx1.wait();
  const tx2 = await VoteFactory.setViewAddress(ViewAddress);
  await tx2.wait();
  const tx3 = await ProposalFactory.setViewAddress(ViewAddress);
  await tx3.wait();
  const tx4 = await FundingFactory.setViewAddress(ViewAddress);
  await tx4.wait();
  const tx5 = await AgoraToken.setViewAddress(ViewAddress);
  await tx5.wait();
  const tx6 = await CwrongNFT.setViewAddress(ViewAddress);
  await tx6.wait();
  const tx7 = await CwrongGov.setViewAddress(ViewAddress);
  await tx7.wait();

  console.log(await GovDatabase.getViewAddress());
  console.log(await VoteFactory.getViewAddress());
  console.log(await ProposalFactory.getViewAddress());
  console.log(await FundingFactory.getViewAddress());
  console.log(await AgoraToken.getViewAddress());
  console.log(await CwrongNFT.getViewAddress());
  console.log(await CwrongGov.getViewAddress());
}

main();
