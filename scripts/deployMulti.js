// scripts/deployMulti.js

const hre = require("hardhat");

async function main() {
  // We get the contract to deploy.
  const DynamicNFTMulti = await hre.ethers.getContractFactory("DynamicNFTMulti");
  const dynamicNFTMulti = await DynamicNFTMulti.deploy();

  await dynamicNFTMulti.deployed();

  console.log("DynamicNFTMulti deployed to:", dynamicNFTMulti.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });