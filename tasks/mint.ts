import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import { tokenAddress } from "../config";


task("mint", "mint a new NFT token")
.addOptionalParam("addressTo", "address to own new NFT")
.addOptionalParam("uri", "URI of NFT picture")
.setAction(async (taskArgs, hre) => {
    const token = await hre.ethers.getContractAt("NFT721token", tokenAddress);
    const tx = await token.mint(taskArgs.addressTo, taskArgs.uri);
    await tx.wait();
    console.log(`${taskArgs.addressTo} get new NFT`);
});