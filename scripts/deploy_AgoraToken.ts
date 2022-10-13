// import { ethers } from "hardhat";
// import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
// import { AgoraToken } from "../typechain";
// import fs from "fs";

// export interface RT {
//   agoraManager: SignerWithAddress;
//   agoraToken: AgoraToken;
// }

// export const deployAllContracts = async (): Promise<RT> => {
//   const [agoraManager] = await ethers.getSigners();

//   const AgoraTokenContract = await ethers.getContractFactory("AgoraToken");
//   const agoraToken = (await AgoraTokenContract.deploy("AgoraToken", "AGT")) as AgoraToken;
//   await agoraToken.deployed();

//   console.log("Your deployed contract address : ", agoraToken.address);

//   fs.writeFile("./deployedAddress", agoraToken.address, (err) => {
//     if (err) {
//       console.log(err);
//       return;
//     }
//   });

//   return {
//     agoraManager,
//     agoraToken,
//   };
// };

const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const AgoraToken = await hre.ethers.getContractFactory("AgoraToken");
  const agoraToken = await AgoraToken.deploy();

  await agoraToken.deployed();

  console.log("Your deployed contract address:", agoraToken.address);

  const buffer = fs.readFileSync("./deployedAddress.json");
  const data = buffer.toString();
  const dict = JSON.parse(data);

  dict.AgoraToken = agoraToken.address;

  const dictJSON = JSON.stringify(dict);
  fs.writeFileSync("./deployedAddress.json", dictJSON);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
