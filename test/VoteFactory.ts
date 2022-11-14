import { ethers } from "hardhat";
import { expect } from "chai";

describe("voteFactory", async function () {
  async function deployVoteFactory() {
    const [signer] = await ethers.getSigners();

    const VoteFactory = await ethers.getContractFactory("VoteFactory");
    const voteFactory = await VoteFactory.deploy("0xc6568ca214371EE4165D663C0E69E05E4F98262b");

    await voteFactory.deployed();

    return { signer, voteFactory };
  }

  it("print empty mapping", async function () {
    const { signer, voteFactory } = await deployVoteFactory();

    await voteFactory.createVote(0, 0, 0, signer.address);

    console.log(await voteFactory.getVoteCount(0));

    expect(await voteFactory.getVoteCount(0)).to.equal(1);
  });
});
