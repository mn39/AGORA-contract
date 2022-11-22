import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { CwrongNFTAddress } from "./01_ContractInfo";

async function main() {
  const [leader] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", leader.address);
  console.log("Account balance:", (await leader.getBalance()).toString());

  const CwrongNFT = await hre.ethers.getContractAt("CwrongNFT", CwrongNFTAddress, leader);

  const nftID_leader = await CwrongNFT.ownerID(leader.address);

  console.log(`leader nft id is ${nftID_leader}`);

  const url = "https://ipfs.io/ipfs/bafyreidlx7qt6i5bxy5sp4pclodmm6nv5w7qk6tkxgbemzy72ljtboibwq/metadata.json";

  const tx1 = await CwrongNFT.setBaseURI(url);
  await tx1.wait();

  const uri = await CwrongNFT.tokenURI(0);

  console.log(`uri is ${uri}`);
}

main();
