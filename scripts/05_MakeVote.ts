import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { CwrongGovAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, signer);

  const govID = await CwrongGov.getGovId();
  const voteID = await CwrongGov.getVoteCount();

  console.log(`govID : ${govID}`);
  console.log(`voteID : ${voteID}`);

  const time = new Date();
  time.setDate(time.getDate() + 1);
  const deadline = time.getTime();

  const tx1 = await CwrongGov.createVote(govID, voteID, deadline, signer.address);
  await tx1.wait();

  const voteAddress = CwrongGov.getVoteAddress(voteID);

  console.log(`voteAddress : ${voteAddress}`);
  console.log(`VoteCount : ${await CwrongGov.getVoteCount()}`);
  console.log(`getVoteAddress : ${await CwrongGov.getVoteAddress(voteID)}`);
}

main();
