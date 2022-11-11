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

  const time = new Date();
  time.setDate(time.getDate() + 1);

  const voteAddress = await CwrongGov.createVote(govID, voteID, time, signer.address);
  voteAddress.wait();

  console.log(`voteAddress : ${voteAddress}`);
  console.log(`VoteCount : ${await CwrongGov.getVoteCount()}`);
  console.log(`getVoteAddress : ${await CwrongGov.getVoteAddress(voteID)}`);
}

main();
