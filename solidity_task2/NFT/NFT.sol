// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    constructor(string memory name,string memory symbol) ERC721(name,symbol) Ownable(msg.sender){
        _nextTokenId = 1;
    }

    function mint (address to,string memory tokenURI) public onlyOwner returns (uint256){
        uint256 tokenId = _nextTokenId;
        _mint(to,tokenId);
        _setTokenURI(tokenId,tokenURI);
        _nextTokenId++;
        return tokenId;
    }
}
    
