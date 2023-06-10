const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env"});
const { CONNECTLIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants")

async function main() {
  // Address of the connectlist contract that you deployed in the previous module
  const   connectlistContract = CONNECTLIST_CONTRACT_ADDRESS;
  // URL from where we can extract the metadata for the GNIE NFT
  const metadataURL = METADATA_URL
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart cotract,
  so GNIEContract here is a factory for instances of our GNIE contacts.
  */
 const GNIEContract = await ethers.getContractFactory("GNIE");

 // deploy the contract 
 const deployedGNIEContract = await GNIEContract.deploy(
  metadataURL,
  connectlistContract
 );

 // Wait for it finish deploying
 await deployedGNIEContract.deployed();

 // print the address of the deployed contract
 console.log(
  "GNIE Contract Address:",
  deployedGNIEContract.address
 );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 