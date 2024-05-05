import React, { useState, useEffect } from "react";
import web3Modal from "web3modal";
import { ethers } from "ethers";

// internal imports

import Tracking from "./Tracking.json";
const ContractAddress = "0x296179DF9077b197fAc68e5714BE9B4FB4Ab7CFA";
const ContractABI = Tracking.abi;


// fetch the smart contract 

const fetchContract = (signerOrProvider) => 
    new ethers.Contract(ContractAddress, ContractABI, signerOrProvider);


export const Trackingcontext = React.createContext();// this is to make the context global

export const Trackingprovider = ({ children }) => {
    // State variables

    const DappName = "Product Tracking Dapp";// name of the Dapp
    const [currentAccount, setCurrentAccount] = useState("");// current address of the user who is in track

    const createShipment = async (items) => {
        console.log(items);
        const {receiver, pickupTime, distance, price} = items;

        try {

            const web3Modal = new web3Modal();
            const connection = await web3Modal.connect();
            const provider = new ethers.providers.Web3Provider(connection);
            const signer = provider.getSigner();
            const contract = fetchContract(signer);
            const createItem = await contract.createShipment(
                receiver,
                new Date(pickupTime).getTime(),// this will convert the time in timestamp.
                distance, 
                ethers.utils.parseUnits(parse, 18),
            )
        }// this is the entire connection from the user to the connection..
    }

}

