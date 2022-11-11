import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { GovDatabaseAddress, CwrongGovAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const GovDatabase = await hre.ethers.getContractAt("GovDatabase", GovDatabaseAddress, signer);

  const govAddress = await GovDatabase.setNewGov(CwrongGovAddress).wait();

  console.log(govAddress);
  console.log(`GovCount : ${await GovDatabase.getGovCount()}`);
  console.log(`CwrongGovAddress : ${await GovDatabase.getGovAddress(0)}`);
}

main();
