# Create An ERC-6551 Tokenbound Account with an ERC-721 NFT

## What is ERC-6551 and Tokenbound Accounts (TBA)?

ERC-6551 gives NFTs its own wallet address. This means your NFT will be able to own assets, interact with apps and participate as sovereign agents.
A tokenbound account is

### What's so great about it?
- It requires zero changes to your NFT smart contract

Read more about ERC-6551 [here](https://eips.ethereum.org/EIPS/eip-6551)

## How to use this repo
This repository is used in conjunction with Remix IDE, an instant online editor with a GUI for developing smart contracts.

Simple clone this into a new Remix workspace, compile the contracts, deploy and voila. You're on your way!

## Repository Anatomy

The 'scripts' folder has four typescript files which help to deploy the 'Storage' contract using 'web3.js' and 'ethers.js' libraries.

For the deployment of any other contract, just update the contract's name from 'Storage' to the desired contract and provide constructor arguments accordingly 
in the file `deploy_with_ethers.ts` or  `deploy_with_web3.ts`

