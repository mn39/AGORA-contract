import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { Contract } from "hardhat/internal/hardhat-network/stack-traces/model";
import { CwrongGovAddress, AgoraTokenAddress } from "./01_ContractInfo";

async function main() {
  const [leader, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", leader.address);
  console.log("Account balance:", (await leader.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, leader);
  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, leader);

  const voteAddress0 = await CwrongGov.getVoteAddress(0);
  const voteAddress1 = await CwrongGov.getVoteAddress(1);

  console.log(`voteAddress0 : ${voteAddress0}`);
  console.log(`voteAddress1 : ${voteAddress1}`);

  const Vote0 = await hre.ethers.getContractAt("Vote", voteAddress0, leader);
  const Vote1 = await hre.ethers.getContractAt("Vote", voteAddress1, leader);

  const { uint1: op01, uint2: op02, uint3: op03, uint4: op04 } = await Vote0.voteStatus();
  const { uint1: op11, uint2: op12, uint3: op13, uint4: op14 } = await Vote1.voteStatus();

  console.log(`Vote 0 => op1:${op01}, op2:${op02}, op3:${op03}, op4:${op04}`);
  console.log(`Vote 1 => op1:${op11}, op2:${op12}, op3:${op13}, op4:${op14}`);

  const leaderBalance = await AgoraToken.balanceOf(leader.address);
  const memberBalance = await AgoraToken.balanceOf(member.address);
  const voterBalance = await AgoraToken.balanceOf(voter.address);
  const voteContractBalance0 = await AgoraToken.balanceOf(voteAddress0);
  const voteContractBalance1 = await AgoraToken.balanceOf(voteAddress1);

  console.log(`leaderBalance : ${leaderBalance}`);
  console.log(`memberBalance : ${memberBalance}`);
  console.log(`voterBalance : ${voterBalance}`);
  console.log(`voteContractBalance0 : ${voteContractBalance0}`);
  console.log(`voteContractBalance1 : ${voteContractBalance1}`);

  const tx1 = await Vote0.finish();
  await tx1.wait();
  const tx2 = await Vote1.finish();
  await tx2.wait();

  const result0 = await Vote0.voteResult();
  const result1 = await Vote1.voteResult();

  console.log(`Vote0 result : ${result0}`);
  console.log(`Vote1 result : ${result1}`);

  const leaderBalance_ = await AgoraToken.balanceOf(leader.address);
  const memberBalance_ = await AgoraToken.balanceOf(member.address);
  const voterBalance_ = await AgoraToken.balanceOf(voter.address);
  const voteContractBalance0_ = await AgoraToken.balanceOf(voteAddress0);
  const voteContractBalance1_ = await AgoraToken.balanceOf(voteAddress1);

  console.log(`leaderBalance_ : ${leaderBalance_}`);
  console.log(`memberBalance_ : ${memberBalance_}`);
  console.log(`voterBalance_ : ${voterBalance_}`);
  console.log(`voteContractBalance0_ : ${voteContractBalance0_}`);
  console.log(`voteContractBalance1_ : ${voteContractBalance1_}`);
}

main();
