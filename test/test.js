const { expect } = require('chai')
const { BigNumber } = require('ethers')
const { ethers } = require('hardhat')
const Web3 = require('web3')

const web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:9545/'))
let contract
let accounts

describe('Contract', () => {
  before(async () => {
    const Contract = await ethers.getContractFactory('Contract')
    contract = await Contract.deploy()
    await contract.deployed()
    accounts = await ethers.getSigners()
  })

  it('can get contract balance', async () => {
    const balance = await contract.getBalance()
    expect('0').to.equal(web3.utils.fromWei(balance.toString()))
  })

  it('can add an agreement', async () => {
    const today = new Date()
    const tomorrow = new Date()
    tomorrow.setDate(today.getDate() + 1)
    const agreementId = await contract.newAgreement(
      accounts[1].getAddress(),
      accounts[2].getAddress(),
      'Some property address...',
      1,
      3,
      web3.utils.toWei('2', 'ether')
    )
    const result = await agreementId.wait()
    expect(result.status).to.eql(1)
    expect(result.confirmations).to.eql(1)
  })

  it('can get the current agreement id', async () => {
    const id = await contract.id()
    expect(id).to.eql(BigNumber.from(1))
  })

  it('can get an agreement by its id', async () => {
    const agreement = await contract.getAgreement(1)
    expect(agreement[0]).to.equal('1')
    expect(agreement[1]).to.equal(accounts[1].address)
    expect(agreement[2]).to.equal(accounts[2].address)
  })

  it('can pay ether into an agreement', async () => {
    const result = await contract.payAgreement(1, { value: web3.utils.toWei('0.5', 'ether') })
    console.log(result)
  })

  it('can pay up to the agreement amount', async () => {
    await contract.payAgreement(1, {
      value: web3.utils.toWei('0.5', 'ether'),
    })
  })

  it('cant pay over the agreement amount', async () => {
    await expect(
      contract.payAgreement(1, { value: web3.utils.toWei('2', 'ether') })
    ).to.be.revertedWith("Can't over pay")
  })

  it('can forward the funds to the landlord and close the agreement', async () => {
    await contract.payLandlord(1)
    const agreement = await contract.getAgreement(1)
    expect(agreement[7]).to.equal('0')
  })

  it('has no balance when the agreement is completed', async () => {
    const balance = await contract.getBalance()
    expect('0').to.equal(web3.utils.fromWei(balance.toString()))
  })
})
