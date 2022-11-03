import { ethers } from "hardhat";
import { View, GovDatabase, VoteFactory, AgoraToken, CwrongNFT } from "../deployedAddress.json";
import ViewInterface from "../abi/View.json";
import GovDatabaseInterface from "../abi/GovDatabase.json";
import VoteFactoryInterface from "../abi/VoteFactory.json";
// import ProposalFactoryInterface from '../abi/ProposalFactory.json';
// import FundingFactoryInterface from '../abi/FundingFactory.json';
import AgoraTokenInterface from "../abi/AgoraToken.json";
import CwrongNFTInterface from "../abi/CwrongNFT.json";
import CwrongGovInterface from "../abi/CwrongGov.json";
import VoteInterface from "../abi/Vote.json";
// import ProposalInterface from '../abi/Proposal.json';
// import FundingInterface from '../abi/Funding.json';

export {
  View as ViewAddress,
  GovDatabase as GovDatabaseAddress,
  VoteFactory as VoteFactoryAddress,
  AgoraToken as AgoraTokenAddress,
  CwrongNFT as CwrongNFTAddress,
  ViewInterface,
  GovDatabaseInterface,
  VoteFactoryInterface,
  AgoraTokenInterface,
  CwrongNFTInterface,
  CwrongGovInterface,
  VoteInterface,
};
