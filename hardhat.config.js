require('dotenv').config({path:__dirname+'/.env'})
require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
    },
    rinkeby: {
      url: process.env.ALCHEMY,
      accounts: [process.env.KEY],
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN
  },
  solidity: "0.8.9",
};
