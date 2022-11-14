import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { AgoraTokenAddress } from "./01_ContractInfo";

async function main() {
  const [signer, voter] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const AgoraToken = await hre.ethers.getContractAt("AgoraToken", AgoraTokenAddress, signer);

  const receiver = voter.address;

  const tx1 = await AgoraToken.transfer(receiver, 1000);
  await tx1.wait();

  const myBalance = await AgoraToken.balanceOf(signer.address);
  const receiverBalance = await AgoraToken.balanceOf(receiver);

  console.log(`My Balance is ${myBalance}`);
  console.log(`receiverBalance is ${receiverBalance}`);
}

main();
