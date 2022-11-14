import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { AgoraTokenAddress, CwrongGovAddress } from "./01_ContractInfo";

async function main() {
  const [signer, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", voter.address);
  console.log("Account balance:", (await voter.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, voter);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, voter);

  const voteAddress = await CwrongGov.getVoteAddress(1);

  console.log(`voteAddress : ${voteAddress}`);

  const Vote = await hre.ethers.getContractAt("Vote", voteAddress, voter);

  const tx1 = await Vote.voteOne(2, 100);
  await tx1.wait();

  const myBalance = await AgoraToken.balanceOf(signer.address);
  const voterBalance = await AgoraToken.balanceOf(voter.address);
  const voteContractBalance = await AgoraToken.balanceOf(voteAddress);
  const govBalance = await AgoraToken.balanceOf(CwrongGovAddress);

  console.log(`myBalance : ${myBalance}`);
  console.log(`voterBalance : ${voterBalance}`);
  console.log(`voteContractBalance : ${voteContractBalance}`);
  console.log(`govBalance : ${govBalance}`);
}

main();
