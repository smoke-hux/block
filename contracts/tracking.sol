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

    function createShipment(address _receiver, uint256 _pickupTime, uint256 _distance, uint256 _price) public payable {
        require(msg.value == _price, "Incorrect payment amount");// this is to check if the payment amount is correct

        Shipment memory shipment = Shipment(msg.sender, _receiver, _pickupTime, 0, _distance, _price, ShipmentStatus.PENDING, false);// this is the data of the shipment updating

        shipments[msg.sender].push(shipment);// this is to add the shipment to the mapping 
        shipmentCount++; // this is to keep track of the number of shipment we are tracking

        TypeShipment.push(
            TypeShipment(
                msg.sender,
                _receiver,
                _pickupTime,
                0,
                _distance,
                ShipmentStatus.PENDING,
                false
            )
        ); // this is to add the shipment to the typeShipment for the purpose for the display

        emit ShipmentCreated(msg.sender, _receiver, _pickupTime, _distance, _price);// this is to emit the event

    }

    // now we have to create function called startShipment that will notify the sender and reciever that item has started being shiped

    function startShipment(address _sender, address _receiver, uint _index) public {
        Shipment storage shipment = shipments[_sender][_index];
        TypeShipment storage typeShipment = TypeShipment[_index];

        require(shipment.receiver == _receiver, "Incorrect receiver");// this is to check if the receiver is correct,
        require(shipment.status == ShipmentStatus.PENDING, "Shipment already started");// this is to check if the shipment is already started
        shipment.status = ShipmentStatus.INTRANSIT;// this is to update the status of the shipment
        typeShipment.status = ShipmentStatus.INTRANSIT;// this is to update the status of the shipment in the typeShipment

        emit ShipmentInTransit(_sender, _receiver, shipment.pickupTime); // this is to emit the event that the shipment has started
    }

    function completeShipment(address _sender, address _receiver, uint _index) public {
        Shipment storage shipment = shipments[_sender][_index];
        TypeShipment storage typeShipment = TypeShipment[_index];  

        require(shipment.receiver == _receiver, "Incorrect receiver");// this is to check if the receiver is correct
        require(shipment.status == ShipmentStatus.INTRANSIT, "Shipment not started");// this is to check if the shipment is not started
        require(!shipment.isPaid, "Shipment already completed");// this is to check if the shipment is already completed
        shipment.status = ShipmentStatus.DELIVERED;// this is to update the status of the shipment
        typeShipment.status = ShipmentStatus.DELIVERED;// this is to update the status of the shipment in the typeShipment  
        typeShipment.deliveryTime = block.timestamp;// this is to update the delivery time of the shipment in the typeShipment
        shipment.deliveryTime = block.timestamp;// this is to update the delivery time of the shipment


        uint256 amount = shipment.price;// this is to update the amount of the shipment

        payable(shipment.sender).transfer(amount);// this is to transfer the amount of the shipment to the sender

        shipment.isPaid = true;
        typeShipment.isPaid = true;// this is to update the status of the shipment in the typeShipment

        emit ShipmentDelivered(_sender, _receiver, shipment.deliveryTime);// this is to emit the event that the shipment has completed
        emit ShipmentPaid(_sender, _receiver, amount);

    }


    function getShipment(address _sender, uint256 _index) public view returns (address, address, uint256, uint256, uint256, uint256, ShipmentStatus, bool){
        Shipment memory shipment = shipments[_sender][_index]; // this is to get the shipment from the mapping
        return (shipment.sender, Shipment.distance , shipment.price, shipment.status, shipment.isPaid);// we are returning all the data of the shipment
    }

    function getShipmentsCount(address _sender) public view returns (uint256) {
        return shipments[_sender].length;
    } // this will give us the number of the shipment that are created by the user

    function getAllTransactions()
    public view
    returns (TypeShipment[] memory)//  we are using the memory keyword to return the data of the shipment
    {
        return TypeShipment;
    }

    

}