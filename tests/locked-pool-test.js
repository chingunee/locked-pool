const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LockedPool", function () {
  let LockedPool, lockedPool, MockToken, mockToken, owner, addr1, addr2;

  beforeEach(async function () {
    // Deploy MockToken
    MockToken = await ethers.getContractFactory("MockToken");
    [owner, addr1, addr2, _] = await ethers.getSigners();
    mockToken = await MockToken.deploy(owner.address);

    // Deploy LockedPool
    const currentTimestamp = (await ethers.provider.getBlock("latest"))
      .timestamp;
    LockedPool = await ethers.getContractFactory("LockedPool");
    lockedPool = await LockedPool.deploy(
      owner.address,
      mockToken.address,
      currentTimestamp + 500, // market unlock time
      currentTimestamp + 1000 // employment unlock time
    );

    // Give addr1 some tokens and approve LockedPool to spend them
    await mockToken.mint(addr1.address, ethers.utils.parseEther("1000"));
    await mockToken
      .connect(addr1)
      .approve(lockedPool.address, ethers.utils.parseEther("1000"));
  });

  describe("Deposits", function () {
    it("should allow deposits to the market pool", async function () {
      await lockedPool
        .connect(addr1)
        .depositForMarketPool(addr1.address, ethers.utils.parseEther("100"));
      expect(
        await lockedPool.balanceOfMarket(mockToken.address, addr1.address)
      ).to.equal(ethers.utils.parseEther("100"));
    });

    it("should reject zero amount deposits", async function () {
      await expect(
        lockedPool.connect(addr1).depositForMarketPool(addr1.address, 0)
      ).to.be.revertedWith("DepositAmountCannotBeZero");
    });
  });

  describe("Withdrawals", function () {
    beforeEach(async function () {
      await lockedPool
        .connect(addr1)
        .depositForMarketPool(addr1.address, ethers.utils.parseEther("100"));
    });

    it("should allow withdrawals from the market pool after unlock time", async function () {
      // Increase time to after unlock
      await ethers.provider.send("evm_increaseTime", [501]);
      await ethers.provider.send("evm_mine");

      await lockedPool
        .connect(addr1)
        .withdrawMarketPool(ethers.utils.parseEther("100"));
      expect(
        await lockedPool.balanceOfMarket(mockToken.address, addr1.address)
      ).to.equal(0);
    });

    it("should prevent withdrawals before unlock time", async function () {
      await expect(
        lockedPool
          .connect(addr1)
          .withdrawMarketPool(ethers.utils.parseEther("100"))
      ).to.be.revertedWith("You can't withdraw yet");
    });
  });

  describe("Administrative Controls", function () {
    it("should pause and unpause the contract", async function () {
      await lockedPool.pause();
      expect(await lockedPool.paused()).to.equal(true);

      await lockedPool.unpause();
      expect(await lockedPool.paused()).to.equal(false);
    });
  });
});
