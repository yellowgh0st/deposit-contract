const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('DepositContract', function () {
  it('Should deploy', async function () {
    const Contract = await ethers.getContractFactory('DepositContract')
    const contract = await Contract.deploy(
      '0x644C9dC206733F3DccEcf526bb09fd6D5170b246',
      '0x01be23585060835e02b77ef475b0cc51aa1e0709',
      '0x27130dea848316Da072484027EC66cfb37e7B0df',
    )
    console.log(`    Address: ${contract.address}`)
    expect(await contract.deployed())
    expect(contract.address).to.not.be.undefined;
    expect(contract.address).to.not.be.null;
    expect(contract.address).not.equal(0x0);
    expect(contract.address).not.equal('');
  });
});
