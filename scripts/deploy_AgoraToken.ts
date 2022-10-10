import { ethers, upgrades } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { VoteFactory, Vote, AgoraToken } from "../typechain";
import fs from "fs";

export interface RT {
  agoraManager: SignerWithAddress;
  agoraToken: AgoraToken;
}

export const deployAllContracts = async (): Promise<RT> => {
  const [agoraManager] = await ethers.getSigners();

  const AgoraTokenContract = await ethers.getContractFactory("AgoraToken");
  const agoraToken = (await AgoraTokenContract.deploy("AgoraToken", "AGT")) as AgoraToken;
  await agoraToken.deployed();

  console.log("Your deployed contract address : ", agoraToken.address);

  fs.writeFile("./deployedAddress", agoraToken.address, (err) => {
    if (err) {
      console.log(err);
      return;
    }
  });

  return {
    agoraManager,
    agoraToken,
  };
};
