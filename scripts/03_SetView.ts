import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { ViewAddress, GovDatabaseAddress, VoteFactoryAddress, AgoraTokenAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const View = await hre.ethers.getContractAt("View", ViewAddress, signer);

  await View.setTokenAddress(AgoraTokenAddress).wait();
  await View.setVoteFactoryAddress(VoteFactoryAddress).wait();
  await View.setGovDatabaseAddress(GovDatabaseAddress).wait();

  console.log(await View.getTokenAddress());
  console.log(await View.getVoteFactoryAddress());
  console.log(await View.getGovDatabaseAddress());
}

main();
