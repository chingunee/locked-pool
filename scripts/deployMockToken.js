async function main() {
  const initialOwner = "0x863715bc289526306BAa26569b31714c0e5F9397";
  const mockToken = await ethers.deployContract("MockToken", [initialOwner]);
  const mockTokenAddress = await mockToken.getAddress();
  console.log("MockToken Contract Address: ", mockTokenAddress);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
