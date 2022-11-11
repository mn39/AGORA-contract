import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { AgoraTokenAddress, CwrongGovAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, signer);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, signer);

  const voteAddress = await CwrongGov.getVoteAddress(0);

  const Vote = await hre.ethers.getContractAt("Vote", voteAddress, signer);

  await Vote.voteOne(0, 10).wait();

  const myBalance = await AgoraToken.getBalance(signer);
  const govBalance = await AgoraToken.getBalance(CwrongGovAddress);

  console.log(`voteAddress : ${voteAddress}`);
  console.log(`myBalance : ${myBalance}`);
  console.log(`govBalance : ${govBalance}`);
}

main();
