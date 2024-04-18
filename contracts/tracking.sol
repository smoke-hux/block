// SPDX-Licence-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Tracking {
    enum ShipmentStatus { PENDING, INTRANSIT, CANCELLED, DELIVERED }

    struct Shipment {
        address sender;
        address receiver;
        uint256 pickupTime;
        uint256 deliveryTime;
        uint256 distance;
        uint256 price;
        ShipmentStatus status;
        bool isPaid;
    }

    mapping(address => Shipment) public shipments; // mapping from sender to shipment info
    uint256 public shipmentCount; // this will keep track of the number of the shipment we are tracking

    struct TypeShipment {
        address sender;
        address reciever;
        uint pickupTime;
        uint deliveryTime;
        uint distance;
        uint price;
        ShipmentStatus status;
        bool isPaid;
    }
}