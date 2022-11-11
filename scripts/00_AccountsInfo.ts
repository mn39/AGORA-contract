import hre from "hardhat";
import { mainModule } from "process";

async function main() {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(`${account.address} => ${await account.getBalance()}`);
  }
}

main();
