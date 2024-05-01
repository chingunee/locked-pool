async function main() {
  const _signer = "0x900a7A576E37d1dc9B6B8D31BDdd78470052f8F7";
  const _weth = "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9";
  const _tokensAllowed = ["0xeBB643800FF0bfCf4D4b3446B78654f924d1907F"];
  const eigenFi = await ethers.deployContract("EigenFiPool", [
    _signer,
    _tokensAllowed,
    _weth,
  ]);
  const eigenFiAddress = await eigenFi.getAddress();
  console.log("EigenFi Contract Address: ", eigenFiAddress);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
