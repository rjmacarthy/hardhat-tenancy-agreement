const { expect } = require('chai')
const { BigNumber } = require('ethers')
const { ethers } = require('hardhat')
const Web3 = require('web3')
require('@nomiclabs/hardhat-waffle')

const web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:9545/'))
let contract
let accounts

describe('Contract', function () {
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
      Math.floor(today / 1000),
      Math.floor(today / 1000),
      web3.utils.toWei('1', 'ether')
    )
    const result = await agreementId.wait()
    expect(result.status).to.eql(1)
    expect(result.confirmations).to.eql(1)
  })

  it('can get the current agreement id', async () => {
    const id = await contract.id()
    expect(id).to.eql(BigNumber.from(1))
  })
})
