require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();




/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },
    'lisk-sepolia': {
      url: `https://rpc.sepolia-api.lisk.com`,
      accounts: [process.env.PRIVATE_KEY],
      gasPrice: 1000000000,

    }
    
  }
};
