import React, { useState, useEffect } from "react";
import web3Modal from "web3modal";
import { ethers } from "ethers";

// internal imports

import Tracking from "./Tracking.json";
import { setBlockGasLimit } from "@nomicfoundation/hardhat-toolbox/network-helpers";
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
                ethers.utils.parseUnits(parse, 18),{
                    value: ethers.utils.parseUnits(price, 18)
                }

            );
            await createItem.wait();
            console.log(createItem);
        }// this is the entire connection from the user to the connection..
        catch (error) {
            console.log("something went wrong", error);
        }
    }

    // this will allow us to get all the shipment that the user will create in our dapp so that we can get 
    // from our dapp and display it on the UI.

    const getAllShipment = async () => {
        try {
        const provider = new ethers.providers.JsonRpcProvider();
        const contract = fetchContract(provider);

        const shipments = await contract.getAllTransactions();
        const allshipments = shipments.map((shipment) => ({
            sender: shipment.sender,
            receiver: shipment.receiver,
            price: ethers.utils.formatEther(shipment.price.toString()),
            pickupTime: shipment.pickupTime.toNumber(),
            deliveryTime: shipment.deliverTime.toNumber(),
            distance: shipment.distance.toNumber(),
            isPaid: shipment.isPaid,
            status: shipment.status,
        }));
        return allShipments;
    } catch (error) {
        console.log("there is and error, getting shipment");

    }}

    const getShipmentCount = async () => {
        try {
            if (!window.ethereum) return "install Metamask";
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            const provider = new ethers.providers.JsonRpcBatchProvider();
            const contrac = fetchContract(provider);
            const shipmentcount = await contract.getShipmentCount(accounts[0]);
            return shipmentcount.toNumber();
        } catch (error) {
            console.log("something went wrong", error);
        }
    }

    const completeShipment = async (shipmentId) => {
        console.log(completShip);

        const {receiver, index } = completShip;
        try {
            if (!window.ethereum) return "install Metamask";

            const accounts = await window.ethereum.request({
                method: "eth_accounts",
            })

            const web3Modal = new web3Modal();
            const connection = await web3Modal.connect();
            const provider = new ethers.providers.Webweb3Provider(connection);
            const signer = provider.getsigner();
            const contract = fetchContract(signer);

            const transaction = await contract.completeShipment(
                accounts[0],
                receiver, 
                index, {
                    gaslimit: 300000,
                }
            )

            transaction.wait();
            console.log(transaction)
        } catch (error) { 
            console.log("wrong shipment so not complete", error );
    }}

    const getShipment = async (index) => {
        console.log(index * 1);
        try {
            if (!window.ethereum) return "install Metamask";
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            })

            const provider = new ethers.providers.JsonRpcBatchProvider();
            const contract = fetchContract(provider);
            const shipment = await contract.getShipment(
                accounts[0],

                index * 1
            );
            const SingleShipment = {
                sender: shipment[0],
                receiver: shipment[1],
                pickupTime: shipment[2].toNumber(),// this will convert the time in timestamp.
                deliveryTime: shipment[3].toNumber(),
                distance: shipment[4].toNumber(),
                price: ethers.utils.formatEther(shipment[5].toString()),
                status: shipment[6],
                isPaid: shipment[7],
            };
            return SingleShipment;
        } catch (error) {
            console.log("sorry there is no shipment like that one", error);
        }
    }


    const startShipment = async (getProduct) => {
        const { receiver, index } = getProduct;

        try {
            if (!window.ethereum) return "install Metamask";
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            })

            const web3Modal = new web3Modal();
            const connection = await web3Modal.connect();
            const provider = new ethers.providers.Webweb3Provider(connection);
            const signer = provider.getsigner();
            const contract = fetchContract(signer);
            const shipment = await contract.startShipment(
                account[0],
                receiver,
                index*1
            )

            shipment.wait();
            console.log(shipment);
        } catch (error) {
            console.log("wrong shipment so not complete", error );
        }
    
    }

    // CHECK IF WALLET IS CONNECTED 

    const checkIfwalletIsConnected = async () => {
        
        try {
            if (!window.ethereum) return "install Metamask";
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            if (accounts.length) {
                setCurrentUser(accounts[0])
            } else {
                return "No account found"
            }
            console.log(accounts);
        } catch (error) {
            console.log("not connected to metamask", error);
        }
    }

    // connect wallet function

    const connectWallet = async () => {
        try {
            if (!window.ethereum) return "install Metamask";
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            setCurrentUser(accounts[0]);

    } catch (error) {
        return "Something went wrong "}
    }



    useEffect(() => {
        checkIfwalletIsConnected();
    }, []);
    return (
        <Trackingcontext.provider
            value={{
                connectWallet,
                checkIfwalletIsConnected,
                currentUser,
                createShipment,
                getAllShipment,
                getShipment,
                startShipment,
                completeShipment,
                DappName
            }}>
            {children}  </Trackingcontext.provider>)



}



