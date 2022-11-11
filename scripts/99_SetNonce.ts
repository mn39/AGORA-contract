import hre from "hardhat";

async function main() {
  const [signer] = await hre.ethers.getSigners();
  hre.network.provider.send("hardhat_setNonce", [signer, "0x10"]);
}
