const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MockToken Deployment", function () {
  it("should deploy MockToken successfully", async function () {
    const [owner] = await ethers.getSigners();
    const MockToken = await ethers.getContractFactory("MockToken");
    const mockToken = await MockToken.deploy(owner.address);

    // Check if mockToken is defined and has an address
    expect(mockToken).to.not.be.undefined;
    expect(mockToken.address).to.properAddress;

    console.log("MockToken Address:", mockToken.address);
  });
});
