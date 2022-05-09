import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract } from "ethers";
import { Signer } from "ethers";
import { isAddress } from "ethers/lib/utils";

describe("NFT721token", function () {
  let Token;
  let newToken: Contract;
  let owner: any;
  let addr2: any;
  let addr3: any;
  let addr4 = "0x0000000000000000000000000000000000000000";

  beforeEach(async function () {
    Token = await ethers.getContractFactory("NFT721");
    [owner, addr2, addr3] = await ethers.getSigners();
    newToken = await Token.deploy("MyToken", "MTK");
    await newToken.deployed();
    await newToken.mint(addr2.address, "qwerty")
  });

  it("Checking balanceOf tokens", async function () {
    expect(await newToken.balanceOf(addr2.address)).to.equal(1);
  });

  it("Revert if address 0", async function () {
    await expect(newToken.balanceOf(addr4)).to.be.revertedWith("not valid address");
  });

  it("Checking uri token", async function () {
    expect(await newToken.getUri(0)).to.equal("qwerty");
  });

  it("Checking ownerOf token", async function () {
    expect(await newToken.ownerOf(0)).to.equal(addr2.address);
  });

  it("Revert if token doesn't exist", async function () {
    await expect(newToken.ownerOf(1)).to.be.revertedWith("token doesn't exist");
  });
  
  it("checking approve and allowence", async function () {
    await newToken.mint(owner.address, "qwerty2")
    await newToken.approve(addr2.address, 1);
    expect(await newToken.getApproved(1)).to.equal(addr2.address);
  });

  it("Revert if not an owner, operator or approved", async function () {
    await expect(newToken.approve(addr2.address, 0)).to.be.revertedWith("not allowed");
  });

  it("checking transferFrom", async function () {
    await newToken.mint(owner.address, "qwerty2")
    await newToken.approve(addr2.address, 1);
    await newToken.connect(addr2).transferFrom(owner.address, addr3.address, 1);
    expect(await newToken.ownerOf(1)).to.equal(addr3.address);
    expect(await newToken.balanceOf(addr3.address)).to.equal(1)
  });

  it("checking approve operator for all address tokens", async function () {
    await newToken.setApprovalForAll(addr2.address, true);
    expect(await newToken.isApprovedForAll(owner.address, addr2.address)).to.equal(true);
  });

});