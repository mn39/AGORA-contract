import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import { Bytes } from "ethers";
import hre from "hardhat";
import { CwrongGovAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, signer);

  const govID = await CwrongGov.getGovID();
  const voteID = await CwrongGov.getVoteCount();

  console.log(`govID : ${govID}`);
  console.log(`voteID : ${voteID}`);

  const options = ["morning", "afternoon", "evening"];

  const tx1 = await CwrongGov.createVoteOptioned(1, 3, [
    hre.ethers.utils.formatBytes32String("morning"),
    hre.ethers.utils.formatBytes32String("afternoon"),
    hre.ethers.utils.formatBytes32String("evening"),
  ]);
  await tx1.wait();

  const voteAddress = await CwrongGov.getVoteAddress(voteID);

  console.log(`voteAddress : ${voteAddress}`);
  console.log(`VoteCount : ${await CwrongGov.getVoteCount()}`);
}

main();
