import { ethers } from "hardhat";
import { expect } from "chai";

describe("test", async function () {
  async function deployTest() {
    const [signer] = await ethers.getSigners();

    const Test = await ethers.getContractFactory("test");
    const test = await Test.deploy();

    await test.deployed();

    return { signer, test };
  }

  it("print empty mapping", async function () {
    const { test } = await deployTest();

    await test.setmap(0, 5);

    expect(await test.getmap(0)).to.equal(5);
  });
});
