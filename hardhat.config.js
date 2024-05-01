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
    polygonAmoy: {
      url: API_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: POLYGONSCAN_API_KEY,
    customChains: [
      {
        network: "polygonAmoy",
        chainId: 80002,
        urls: {
          apiURL:
            "https://www.oklink.com/api/explorer/v1/contract/verify/async/c5800cdb-ad74-4e69-a093-32e0294e550d/polygonAmoy",
          browserURL: "https://www.oklink.com/polygonAmoy",
        },
      },
    ],
  },
  sourcify: {
    enabled: true,
  },
  abiExporter: {
    path: "./app/abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    spacing: 2,
  },
};
