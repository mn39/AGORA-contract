import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { ViewAddress, GovDatabaseAddress, VoteFactoryAddress, AgoraTokenAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const View = await hre.ethers.getContractAt("View", ViewAddress, signer);

  const tx1 = await View.setTokenAddress(AgoraTokenAddress);
  await tx1.wait();
  const tx2 = await View.setVoteFactoryAddress(VoteFactoryAddress);
  await tx2.wait();
  const tx3 = await View.setGovDatabaseAddress(GovDatabaseAddress);
  await tx3.wait();

  console.log(await View.getTokenAddress());
  console.log(await View.getVoteFactoryAddress());
  console.log(await View.getGovDatabaseAddress());
}

main();
