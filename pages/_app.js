import "@/styles/globals.css";


// internal imports 

import { Trackingprovider } from "@/Context/tracking";
import { Footer, NavBar, footer } from "@/Component";
export default function App({ Component, pageProps }) {
  return ( <>
  <Trackingprovider> 
  <NavBar />
    <Component {...pageProps} /> 
  </Trackingprovider>
  <Footer />
  </> );
}
