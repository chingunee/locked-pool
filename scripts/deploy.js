async function main() {
  const _owner = "0xCa28eaA4fFF145c26074F3EA08b657B288401E33";
  const _unlockTimePoolOfMarket = 1780243200;
  const _unlockTimePoolOfEmployments = 1748707200;
  const _tokenAdress = "0xf8e81D47203A594245E36C48e151709F0C19fBe8"

  // const _tokensAllowed = ["0x66cf95ABEd306E620680d57BF5aD234409C4B3C5"];

  const lockedPool = await ethers.deployContract("LockedPool", [
    _owner,
    _tokenAdress,
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