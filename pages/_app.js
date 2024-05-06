import "@/styles/globals.css";


// internal imports 

import { Trackingprovider } from "@/Context/tracking";
export default function App({ Component, pageProps }) {
  return ( <>
  <Trackingprovider> 
    <Component {...pageProps} /> 
  </Trackingprovider>
  </> );
}
