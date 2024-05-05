const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("Tracking", (m) => {
  

  const lock = m.contract("Tracking", [], {
    shipmentCount: 0
  })
  return { lock };
});