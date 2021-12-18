const { expect } = require("chai");
const { ethers } = require("hardhat");



 
describe("Funding", function () {
  let fundingContract,nft;
  let owner, addr1, addr2, addr3,addr4,addr5;  
  beforeEach("", async () => {
    const Funding = await ethers.getContractFactory("Funding");
    fundingContract = await Funding.deploy();
    const NFT = await ethers.getContractFactory("MyNFT");
    nft = await NFT.deploy();
    [owner, addr1, addr2,addr3,addr4,addr5] = await ethers.getSigners(); 
  })
    //외부의 nft 작품 minting 시도
    it("Should return the new MyNFT once it's changed", async function () {
    await fundingContract.mintMynftPriced("AA", ethers.utils.parseEther("0.3"));
    await fundingContract.mintMynftPriced("BB", ethers.utils.parseEther("0.2"));
    
    //3. funding
    const data0 = fundingContract.interface.encodeFunctionData("funding", [0]);
    const data1 = fundingContract.interface.encodeFunctionData("funding", [0]);
    const data2 = fundingContract.interface.encodeFunctionData("funding", [0]);
    await addr1.sendTransaction({to: fundingContract.address,value: ethers.utils.parseEther("0.1"),  data: data0,});
    await addr4.sendTransaction({to: fundingContract.address,value: ethers.utils.parseEther("0.1"),  data: data1,});
    await addr5.sendTransaction({to: fundingContract.address,value: ethers.utils.parseEther("0.1"),  data: data2,});


    //4. Funding시에는 MyNFT Minting을 수행
    await nft.connect(addr1).mintMynft("aa",0); 
    await nft.connect(addr4).mintMynft("bb",0); 
    await nft.connect(addr5).mintMynft("cc",0); 

    //5. randomNFTOwner
    await fundingContract.randomNFTOwner(0);
    //6. random 당첨자 선정후 winner 정보를 확인
    const winneraddr = await fundingContract.fundingOwner(0);
    console.log('winner', winneraddr);
    //7. 당첨이 되지 않은 다른 참가자들에겐 다른 NFT 토큰 전송
 
    await nft.randomDeployNFT(0,winneraddr);

 });
});
