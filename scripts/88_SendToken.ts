import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { AgoraTokenAddress } from "./01_ContractInfo";

async function main() {
  const [signer] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, signer);

  const receiver = "0x92be24D66ea0Cc8Fa40e13Cc713E1Ae0527BFfdE";

  const tx1 = await AgoraToken.transfer(receiver, 3000);
  await tx1.wait();

  const myBalance = await AgoraToken.balanceOf(signer.address);

  console.log(`My Balance is ${myBalance}`);
}

main();
