async function main() {
  const _owner = "0x863715bc289526306BAa26569b31714c0e5F9397";
  const _unlockTimePoolOfMarket = 1780243200;
  const _unlockTimePoolOfEmployments = 1748707200;

  const _tokensAllowed = ["0x66cf95ABEd306E620680d57BF5aD234409C4B3C5"];

  const lockedPool = await ethers.deployContract("LockedPool", [
    _owner,
    _unlockTimePoolOfMarket,
    _unlockTimePoolOfEmployments,
  ]);
  const lockedPoolAddress = await lockedPool.getAddress();
  console.log("LockedPool Contract Address: ", lockedPoolAddress);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
