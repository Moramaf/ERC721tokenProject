
import { ethers } from "hardhat";
import { tokenName, tokenSymbol } from "../config";


async function main() {

  const Token = await ethers.getContractFactory("NFT721");
  const token = await Token.deploy(tokenName, tokenSymbol);


  await token.deployed();

  console.log("Token deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
