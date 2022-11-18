import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";
import hre from "hardhat";
import { CwrongNFTAddress } from "./01_ContractInfo";

async function main() {
  const [signer, member, voter, member2] = await hre.ethers.getSigners();

  console.log("Send transaction with the account:", signer.address);
  console.log("Account balance:", (await signer.getBalance()).toString());

  const CwrongNFT = await hre.ethers.getContractAt("CwrongNFT", CwrongNFTAddress, signer);

  const tx1 = await CwrongNFT.mint(member2.address, 2);
  await tx1.wait();

  const nftID_leader = await CwrongNFT.ownerID(signer.address);
  const nftID_member = await CwrongNFT.ownerID(member2.address);

  console.log(`leader nft id is ${nftID_leader}`);
  console.log(`member nft id is ${nftID_member}`);
}

main();
