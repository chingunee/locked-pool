require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-abi-exporter");

const { API_URL, PRIVATE_KEY, POLYGONSCAN_API_KEY } = process.env;

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    polygon: {
      url: API_URL,
      accounts: [PRIVATE_KEY],
    },
    amoy: {
      url: API_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: POLYGONSCAN_API_KEY,
  },
  abiExporter: {
    path: "./app/abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    spacing: 2,
  },
};
