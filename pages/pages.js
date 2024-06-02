import React, { useState, useEffect, useContext } from "react";

// INTERNAL IMPORT

import {
  Table,
  form,
  Service,
  Profile,
  completeShipment,
  StartShipment,
  GetShipment,

} from "../Component";

import { Trackingcontext } from "@/Context/tracking";

const pages = () => {
  const {
    currentUser,
    createShipment,
    getAllShipment,
    GetShipment,
    StartShipment,
    getShipmentCount
  } = useContext(Trackingcontext);


  // STATE VARIABLE

  const [createShipmentModel, setCreateShipmentModel] = useState(false);
  const [openProfile, setOpenProfile] = useState(false);
  const [startModal, setStartModal] = useState(false);
  cosnt [completeModal, setCompleteModal] = useState(false);
  const [getModel, setGetModel] = useState(false);

  // DATA STATE VARIABLE

  const [allShipmentdata, setAllShipmentdata] = useState();

  useEffect(() => {
    const  getCampaignData = getAllShipment();

    return async () => {
      const allData = await getCampaignData;
      setAllShipmentdata(allData);

    };

  },[])

  return (
    <>
    <Service
    setOpenProfile={setOpenProfile}
    setCompleteModal={setCompleteModal}
    setGetModel={setGetModel}
    setStartModal={setStartModal}
    />
    <Table
    setCreateShipmentModel={setcreateShipmentModel}
    allshipmetsdata={allShipmentdata}
    />
    <form
    createShipmentModel={createShipmentModel}
    createShipment={createShipment}
    setCreateShipmentModel={setCreateShipmentModel}
    />
    <Profile
    openProfile={openProfile}
    setOpenProfile={setOpenProfile}
    currentUser={currentUser}
    getShipmentCount={getShipmentCount}
    />
    <completeShipment
    completeModal={completeModal}
    setCompleteModal={setCompleteModal}
    completeShipment={completeShipment}
    />
    <GetShipment
    getModel={getModel}
    setGetModel={setGetModel}
    getShipment={GetShipment}
    />
    <StartShipment
    startModal={startModal}
    setStartModal={setStartModal}
    StartShipment={StartShipment}
    />
    </>
  );

}

export default pages

// this is the same as index.js with what you are working on rem that 

// import Image from "next/image";

// export default function Home() {
//   return (
//     <main className="flex min-h-screen flex-col items-center justify-between p-24">
//        <h1 class="text-3xl font-bold underline">
//     Hello world!
//   </h1>
//     </main>
//   );
// }
