// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require('hardhat')

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile')

  // We get the contract to deploy
  const Contract = await hre.ethers.getContractFactory('DepositContract')
  const contract = await Contract.deploy(
    '0x644C9dC206733F3DccEcf526bb09fd6D5170b246',
    '0x01be23585060835e02b77ef475b0cc51aa1e0709',
    '0x27130dea848316Da072484027EC66cfb37e7B0df',
  )

  await contract.deployed()

  console.log('Deployed to:', contract.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  });
