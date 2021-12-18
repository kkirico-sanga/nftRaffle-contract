const hre = require("hardhat");

async function main() {
  //1. Token 2개 배포
  const MyNFT = await hre.ethers.getContractFactory("MyNFT");
  const myNFT = await MyNFT.deploy();
  const Funding = await hre.ethers.getContractFactory("Funding");
  const funding = await Funding.deploy();
  console.log("myNFT deployed to:", myNFT.address);
  console.log("funding deployed to:", funding.address);

 
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
