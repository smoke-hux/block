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

    TypeShipment[] Shipments;

    event ShipmentCreated(address indexed sender, address indexed receiver, uint256 pickupTime, uint256 distance, uint256 price);
    
    event ShipmentInTransit(address indexed sender, address indexed receiver, uint256 pickupTime);

    event ShipmentDelivered(address indexed sender, address indexed receiver,uint256 deliveryTime);

    event ShipmentPaid(address indexed sender, address indexed receiver, uint256 price);


    constructor() {
        shipmentCount = 0;
    }

    function createShipmet(address _receiver, uint256 _pickupTime, uint256 _distance, uint_price) public payable {
        require(msg.value == _price, "Incorrect payment amount");// this is to check if the payment amount is correct

        Shipment memory shipment = shipment(msg.sender, _reciever, _pickupTime, 0, _distance, _price, ShipmentStatus.PENDING, false);// this is the data of the shipment updating

        shipments[msg.sender].push(shipment);// this is to add the shipment to the mapping 
        shipmentCount++; // this is to keep track of the number of shipment we are tracking

    }

}