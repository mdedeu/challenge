import { expect } from 'chai'
import { ethers } from 'hardhat'
import '@nomiclabs/hardhat-ethers'

import { ETHPool__factory, ETHPool } from '../build/types'

const { getContractFactory, getSigners } = ethers

describe('ETHPool', () => {
  let ETHPool: ETHPool

  beforeEach(async () => {
    const signers = await getSigners();
    const ethpoolFactory = (await getContractFactory('ETHPool', signers[0])) as ETHPool__factory;
    ETHPool = await ethpoolFactory.deploy();
    await ETHPool.deployed();
  })
    
  it('should accept rewards from team', async () => {
    const options = {value: ethers.utils.parseEther("10.0")}

    await ETHPool.functions.depositRewards(options);

    expect(await ethers.provider.getBalance(ETHPool.address)).to.eq(ethers.utils.parseEther("10.0"));
  }),

  it('should accept deposits from users', async () => {
    const options = {value: ethers.utils.parseEther("10.0")}
    const signers = await getSigners();

    await ETHPool.connect(signers[1]).functions.deposit(options);

    expect(await ethers.provider.getBalance(ETHPool.address)).to.eq(ethers.utils.parseEther("10.0"));
  }),

  it('should accept withdrawals from users', async () => {
    const options = {value: ethers.utils.parseEther("10.0")}
    const signers = await getSigners();

    await ETHPool.connect(signers[1]).functions.deposit(options);

    await ETHPool.connect(signers[1]).functions.withdraw();

    expect(await ethers.provider.getBalance(ETHPool.address)).to.eq(ethers.utils.parseEther("0.0"));
  }), 

  it('should reject not-owner rewards', async () => {
    const options = {value: ethers.utils.parseEther("10.0")}
    const signers = await getSigners();

    await expect( ETHPool.connect(signers[1]).functions.depositRewards(options)).to.be.reverted;
  }),

  it('should reject withdrawls without deposit', async () => {
    const options = {value: ethers.utils.parseEther("10.0")}
    const signers = await getSigners();

    await expect( ETHPool.connect(signers[1]).functions.withdraw()).to.be.reverted;
  }),
  it('should give rewards to signer 1', async () => {
    //A should get 20, B should get 10

    const options = {value: ethers.utils.parseEther("10.0")}
    const signers = await getSigners();

    await expect(await ETHPool.connect(signers[1]).functions.deposit(options)).to.changeEtherBalance(signers[1], ethers.utils.parseEther("-10.0") );

    await ETHPool.functions.depositRewards({value: ethers.utils.parseEther("1.0")});

    await expect(await ETHPool.connect(signers[2]).functions.deposit(options)).to.changeEtherBalance(signers[2], ethers.utils.parseEther("-10.0") );

    
    await expect(await ETHPool.connect(signers[1]).functions.withdraw()).to.changeEtherBalance(signers[1], ethers.utils.parseEther("11.0") );

    await expect(await ETHPool.connect(signers[2]).functions.withdraw()).to.changeEtherBalance(signers[2], ethers.utils.parseEther("10.0") );

  })


})
