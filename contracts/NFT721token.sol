//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract NFT721 is AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;

    string public name;
    string public symbol;

    mapping(uint => address) private nftOwner;
    mapping(address => uint) public userBalance;
    mapping(uint => address) public aprovals;
    mapping(address => mapping(address => bool)) public operators;
    mapping(uint256 => string) private tokenURIs;

    bytes32 public constant ADMIN = keccak256("ADMIN");

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN, msg.sender);
    }


    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    modifier notNullAddress(address _address) {
        require(_address != address(0), "not valid address");
        _;
    }

    modifier isTokenExist (uint tokenId_) {
        require(nftOwner[tokenId_] != address(0), "token doesn't exist");
        _;
    }

    modifier isApproved(address _from, uint256 _tokenId) {
        require(msg.sender == nftOwner[_tokenId] || msg.sender == aprovals[_tokenId] || operators[_from][msg.sender], "not allowed");
        _;
    }

    //standart function eip721 bellow:
    function balanceOf(address _owner) public view notNullAddress(_owner) returns(uint256) {
        return userBalance[_owner];
    }
    function ownerOf(uint256 _tokenId) public view isTokenExist(_tokenId) returns(address) {
        return nftOwner[_tokenId];
    }
    
    function transferFrom(address _from, address _to, uint _tokenId) public
    isTokenExist(_tokenId)
    isApproved(_from, _tokenId)
    notNullAddress(_to)
    {
        nftOwner[_tokenId] = _to;
        userBalance[_from] -= 1;
        userBalance[_to] += 1;
        emit Transfer(_from, _to, _tokenId);
    }
    
    function approve(address _approved, uint256 _tokenId) public
    isTokenExist(_tokenId)
    isApproved(_approved, _tokenId)
    {
        aprovals[_tokenId] =_approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        operators[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        return aprovals[_tokenId];
    }

    function getUri(uint256 _tokenId) external view returns (string memory) {
        return tokenURIs[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return operators[_owner][_operator];
    }

    function mint(address newOwner, string memory tokenURI) external notNullAddress(newOwner) onlyRole(ADMIN) {
        uint newTokenId = tokenIds.current();
        nftOwner[newTokenId] = newOwner;
        userBalance[newOwner] += 1;
        tokenURIs[newTokenId] = tokenURI;
        tokenIds.increment();
        emit Transfer(address(0), newOwner, newTokenId);
    }
    
}
