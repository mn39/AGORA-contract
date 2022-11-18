import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { GovDatabaseAddress, CwrongGovAddress, CwrongNFTAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const GovDatabase = await hre.ethers.getContractAt("GovDatabase", GovDatabaseAddress, signer);
  const CwrongGov = await hre.ethers.getContractAt("CwrongGov", CwrongGovAddress, signer);

  const govName = await CwrongGov.getGovName();

  const tx1 = await GovDatabase.setNewGov(CwrongGovAddress, CwrongNFTAddress, govName);
  await tx1.wait();

  const govAddress = await GovDatabase.getGovAddress(0);

  console.log(`GovCount : ${await GovDatabase.getGovCount()}`);
  console.log(`CwrongGovAddress : ${govAddress}`);
}

main();
