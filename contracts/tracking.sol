// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract Tracking is Ownable, ReentrancyGuard, Pausable {
    using SafeCast for uint256;

    enum ShipmentStatus { PENDING, IN_TRANSIT, DELIVERED }

    struct Shipment {
        address sender;
        address receiver;
        uint256 pickupTime;
        uint256 deliverTime;
        uint256 distance;
        uint256 price;
        ShipmentStatus status;
        bool isPaid;
    }

    mapping(address => Shipment[]) public shipments;
    uint256 public shipmentCount;

    struct TypeShipment {
        address sender;
        address receiver;
        uint256 pickupTime;
        uint256 deliverTime;
        uint256 distance;
        uint256 price;
        bool isPaid;
    }

    TypeShipment[] public typeShipments;

    event ShipmentCreated(address indexed sender, address indexed receiver, uint256 pickupTime, uint256 distance, uint256 price);
    event ShipmentInTransit(address indexed sender, address indexed receiver, uint256 pickupTime);
    event ShipmentDelivered(address indexed sender, address indexed receiver, uint256 deliveryTime);
    event ShipmentPaid(address indexed sender, address indexed receiver, uint256 amount);

    constructor() Ownable(msg.sender) {
        shipmentCount = 0;
    }

    function createShipment(address _receiver, uint256 _pickupTime, uint256 _distance, uint256 _price) public payable whenNotPaused nonReentrant {
        require(msg.value == _price, "Incorrect payment");

        Shipment memory shipment = Shipment(
            msg.sender,
            _receiver,
            _pickupTime,
            0,
            _distance,
            _price,
            ShipmentStatus.PENDING,
            false
        );
        
        shipments[msg.sender].push(shipment);
        shipmentCount++;

        TypeShipment memory typeShipment = TypeShipment(
            msg.sender,
            _receiver,
            _pickupTime,
            0,
            _distance,
            _price,
            false
        );

        typeShipments.push(typeShipment);

        emit ShipmentCreated(msg.sender, _receiver, _pickupTime, _distance, _price);
    }

    function startShipment(address _sender, address _receiver, uint256 _index) public onlyOwner whenNotPaused {
        Shipment storage shipment = shipments[_sender][_index];
        require(shipment.receiver == _receiver, "Wrong receiver.");
        require(shipment.status == ShipmentStatus.PENDING, "Shipment already started.");

        shipment.status = ShipmentStatus.IN_TRANSIT;

        emit ShipmentInTransit(_sender, _receiver, shipment.pickupTime);
    }

    function completeShipment(address _sender, address _receiver, uint256 _index) public onlyOwner whenNotPaused nonReentrant {
        Shipment storage shipment = shipments[_sender][_index];
        require(shipment.receiver == _receiver, "Invalid receiver.");
        require(shipment.status == ShipmentStatus.IN_TRANSIT, "Shipment is not in transit yet.");
        require(!shipment.isPaid, "Shipment is already paid.");

        shipment.status = ShipmentStatus.DELIVERED;
        shipment.deliverTime = block.timestamp;

        uint256 amount = shipment.price;

        payable(shipment.sender).transfer(amount);

        shipment.isPaid = true;

        emit ShipmentDelivered(_sender, _receiver, shipment.deliverTime);
        emit ShipmentPaid(_sender, _receiver, amount);
    }

    function getShipment(address _sender, uint256 _index) public view returns (address, address, uint256, uint256, uint256, uint256, ShipmentStatus, bool) {
        Shipment memory shipment = shipments[_sender][_index];
        return (shipment.sender, shipment.receiver, shipment.pickupTime, shipment.deliverTime, shipment.distance, shipment.price, shipment.status, shipment.isPaid);
    }

    function getAllTransactions() public view returns (TypeShipment[] memory) {
        return typeShipments;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
