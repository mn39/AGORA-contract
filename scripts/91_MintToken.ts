import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { AgoraTokenAddress } from "./01_ContractInfo";

async function main() {
  const [signer, voter1, voter2] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, signer);

  const tx1 = await AgoraToken.mintFor(voter1.address, 3000);
  await tx1.wait();

  const tx2 = await AgoraToken.mintFor(voter2.address, 3000);
  await tx2.wait();

  const myBalance = await AgoraToken.balanceOf(signer.address);
  const voter1Balance = await AgoraToken.balanceOf(voter1.address);
  const voter2Balance = await AgoraToken.balanceOf(voter2.address);

  console.log(`My Balance is ${myBalance}`);
  console.log(`voter1Balance is ${voter1Balance}`);
  console.log(`voter2Balance is ${voter2Balance}`);
}

main();
