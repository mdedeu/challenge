import { expect } from 'chai'
import { ethers } from 'hardhat'
import '@nomiclabs/hardhat-ethers'

import { ETHPool__factory, ETHPool } from '../build/types'

const { getContractFactory, getSigners } = ethers

describe('ETHPool', () => {
  let ETHPool: ETHPool

  beforeEach(async () => {
    const signers = await getSigners()
    const counterFactory = (await getContractFactory('ETHPool', signers[0])) as ETHPool__factory
    ETHPool = await counterFactory.deploy()
    await ETHPool.deployed()
    const initialCount = await ETHPool.getCount()
    expect(initialCount).to.eq(0)
    expect(ETHPool.address).to.properAddress
  })

  describe('Team ', async () => {
    it('should accept ether', async () => {
      
    })
  })
  describe('User ', async() => {
    it('should accept deposits', async () => {
      
    }),
    it('should accept withdrawals', async () => {
      
    })
  })
})
