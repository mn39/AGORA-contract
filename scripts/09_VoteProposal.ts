import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { Contract } from "hardhat/internal/hardhat-network/stack-traces/model";
import { CwrongGovAddress } from "./01_ContractInfo";

async function vote_leader() {
  const [leader, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", leader.address);
  console.log("Account balance:", (await leader.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, leader);

  const proposalAddress = await CwrongGov.getProposalAddress(0);

  console.log(`proposalAddress : ${proposalAddress}`);

  const Proposal = await hre.ethers.getContractAt("Proposal", proposalAddress, leader);

  const tx1 = await Proposal.voteOne(0);
  await tx1.wait();

  const { for: f, against: ag, abstain: ab } = await Proposal.voteStatus();

  console.log(`for : ${f}`);
  console.log(`against : ${ag}`);
  console.log(`abstain : ${ab}`);
}

async function vote_proposer() {
  const [leader, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", member.address);
  console.log("Account balance:", (await member.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, member);

  const proposalAddress = await CwrongGov.getProposalAddress(0);

  console.log(`proposalAddress : ${proposalAddress}`);

  const Proposal = await hre.ethers.getContractAt("Proposal", proposalAddress, member);

  const tx1 = await Proposal.voteOne(2);
  await tx1.wait();

  const { for: f, against: ag, abstain: ab } = await Proposal.voteStatus();

  console.log(`for : ${f}`);
  console.log(`against : ${ag}`);
  console.log(`abstain : ${ab}`);
}

async function vote_voter() {
  const [leader, member, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", voter.address);
  console.log("Account balance:", (await voter.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, voter);

  const proposalAddress = await CwrongGov.getProposalAddress(0);

  console.log(`proposalAddress : ${proposalAddress}`);

  const Proposal = await hre.ethers.getContractAt("Proposal", proposalAddress, voter);

  const tx1 = await Proposal.voteOne(1);
  await tx1.wait();

  const { for: f, against: ag, abstain: ab } = await Proposal.voteStatus();

  console.log(`for : ${f}`);
  console.log(`against : ${ag}`);
  console.log(`abstain : ${ab}`);
}

async function vote_member() {
  const [leader, proposer, voter, member] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", member.address);
  console.log("Account balance:", (await member.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, member);

  const proposalAddress = await CwrongGov.getProposalAddress(0);

  console.log(`proposalAddress : ${proposalAddress}`);

  const Proposal = await hre.ethers.getContractAt("Proposal", proposalAddress, member);

  const tx1 = await Proposal.voteOne(1);
  await tx1.wait();

  const { for: f, against: ag, abstain: ab } = await Proposal.voteStatus();

  console.log(`for : ${f}`);
  console.log(`against : ${ag}`);
  console.log(`abstain : ${ab}`);
}

async function main() {
  //await vote_leader();
  //console.log("=============================================");
  //await vote_proposer();
  //console.log("=============================================");
  //await vote_voter();
  //console.log("=============================================");
  await vote_member();
}

main();
