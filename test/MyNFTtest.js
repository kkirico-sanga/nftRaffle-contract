const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyNFT", function () {
  let raffleNFT;
  let owner, addr1, addr2;  
  beforeEach("", async () => {
    const RaffleNFT = await ethers.getContractFactory("MyNFT");
    raffleNFT = await RaffleNFT.deploy();
    [owner, addr1, addr2] = await ethers.getSigners(); 
  })
  it("Should return the new MyNFT once it's changed", async function () { 
     console.log(owner.address);
  });
});
