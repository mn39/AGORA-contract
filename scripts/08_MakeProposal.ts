import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { CwrongGovAddress } from "./01_ContractInfo";

async function main() {
  const [signer, member] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", member.address);
  console.log("Account balance:", (await member.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, member);

  const govID = await CwrongGov.getGovID();
  const proposalID = await CwrongGov.getProposalCount();

  console.log(`govID : ${govID}`);
  console.log(`proposalID : ${proposalID}`);

  const tx1 = await CwrongGov.createProposal(24);
  await tx1.wait();

  const proposalAddress = await CwrongGov.getProposalAddress(proposalID);

  console.log(`proposalAddress : ${proposalAddress}`);
  console.log(`VoteCount : ${await CwrongGov.getProposalCount()}`);
}

main();
