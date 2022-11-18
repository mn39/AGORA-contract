import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { AgoraTokenAddress, CwrongGovAddress } from "./01_ContractInfo";

async function vote1_1() {
  const [signer, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", member.address);
  console.log("Account balance:", (await member.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, member);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, member);

  const voteAddress = await CwrongGov.getVoteAddress(0);

  console.log(`voteAddress : ${voteAddress}`);

  const Vote = await hre.ethers.getContractAt("Vote", voteAddress, member);

  const tx1 = await Vote.voteOne(1, 100);
  await tx1.wait();

  const memberBalance = await AgoraToken.balanceOf(member.address);
  const voterBalance = await AgoraToken.balanceOf(voter.address);
  const voteContractBalance = await AgoraToken.balanceOf(voteAddress);

  console.log(`memberBalance : ${memberBalance}`);
  console.log(`voterBalance : ${voterBalance}`);
  console.log(`voteContractBalance : ${voteContractBalance}`);
}

async function vote1_0() {
  const [signer, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", voter.address);
  console.log("Account balance:", (await voter.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, voter);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, voter);

  const voteAddress = await CwrongGov.getVoteAddress(0);

  console.log(`voteAddress : ${voteAddress}`);

  const Vote = await hre.ethers.getContractAt("Vote", voteAddress, voter);

  const tx1 = await Vote.voteOne(0, 500);
  await tx1.wait();

  const memberBalance = await AgoraToken.balanceOf(member.address);
  const voterBalance = await AgoraToken.balanceOf(voter.address);
  const voteContractBalance = await AgoraToken.balanceOf(voteAddress);

  console.log(`memberBalance : ${memberBalance}`);
  console.log(`voterBalance : ${voterBalance}`);
  console.log(`voteContractBalance : ${voteContractBalance}`);
}

async function vote2_1() {
  const [signer, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", member.address);
  console.log("Account balance:", (await member.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, member);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, member);

  const voteAddress = await CwrongGov.getVoteAddress(1);

  console.log(`voteAddress : ${voteAddress}`);

  const Vote = await hre.ethers.getContractAt("Vote", voteAddress, member);

  const tx1 = await Vote.voteOne(1, 300);
  await tx1.wait();

  const memberBalance = await AgoraToken.balanceOf(member.address);
  const voterBalance = await AgoraToken.balanceOf(voter.address);
  const voteContractBalance = await AgoraToken.balanceOf(voteAddress);

  console.log(`memberBalance : ${memberBalance}`);
  console.log(`voterBalance : ${voterBalance}`);
  console.log(`voteContractBalance : ${voteContractBalance}`);
}

async function vote2_2() {
  const [signer, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", voter.address);
  console.log("Account balance:", (await voter.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, voter);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, voter);

  const voteAddress = await CwrongGov.getVoteAddress(1);

  console.log(`voteAddress : ${voteAddress}`);

  const Vote = await hre.ethers.getContractAt("Vote", voteAddress, voter);

  const tx1 = await Vote.voteOne(2, 600);
  await tx1.wait();

  const memberBalance = await AgoraToken.balanceOf(member.address);
  const voterBalance = await AgoraToken.balanceOf(voter.address);
  const voteContractBalance = await AgoraToken.balanceOf(voteAddress);

  console.log(`memberBalance : ${memberBalance}`);
  console.log(`voterBalance : ${voterBalance}`);
  console.log(`voteContractBalance : ${voteContractBalance}`);
}

async function main() {
  await vote1_1();
  console.log("=============================================");
  await vote1_0();
  console.log("=============================================");
  await vote2_1();
  console.log("=============================================");
  await vote2_2();
}

main();
