// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProductAtOrganization.sol";
import "./ProductPermissions.sol";
import "./ParticipationManager.sol";

contract Product is ProductPermissions {

    // address supplyChain;

    struct ProductInfo {
        string name;
        // string urlPath; // www.wsg.com/api/company/:id
        string id; //TODO: repassar no constructor
    }

    // struct OrganizationEvents {
    //     address organization;
    //     ProductAtOrganization.EventInfo[] events;
    // }

    ProductInfo productInfo;

    mapping(address => address) public organizationToProductAtOrganization;
    address public manager;
    address public pendingManager;

    struct Ownership {
        address manager;
        uint256 startTime;
    }

    Ownership[] public ownershipHistory;

    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can perform this action");
        _;
    }
    
    address patoFactoryAddr;

    event ProductCreated(address indexed productAddress);

    constructor(
        string memory _productName,
        string memory _productId, 
        address _organizationAddress,
        address[] memory _participatingOrganizations
    ) ProductPermissions(_participatingOrganizations)
    {

        productInfo.name = _productName;
        productInfo.id = _productId;
        // productInfo.urlPath = _url;
        manager = msg.sender;
        ownershipHistory.push(Ownership({ manager: msg.sender, startTime: block.timestamp }));


        patoFactoryAddr = address(new PATOFactory());

        organizationToProductAtOrganization[_organizationAddress] = PATOFactory(patoFactoryAddr).deploy(address(this), _organizationAddress, msg.sender);
    }

    function getName() public view returns (string memory) {
        return productInfo.name;
    }

    function getProductAtOrganization(address _organizationAddress) public view returns (address) {
        require(organizationToProductAtOrganization[_organizationAddress] != address(0), "Product not found for this organization");
        return organizationToProductAtOrganization[_organizationAddress];
    }

    //TODO: Alterar para next ownership transnfer, olha para org address array em product permissions e pega proxima posição
    function requestOwnershipTransfer(address newManager) public onlyManager {
        require(newManager != address(0), "New manager cannot be the zero address");
        pendingManager = newManager;
        // emit OwnershipTransferRequested(manager, newManager);
    }

    function approveOwnershipTransfer(address orgAddress) public {
        require(Organization(orgAddress).IsOwner(), "Only owner can approve");
        require(msg.sender == pendingManager, "Only the pending manager can approve the transfer");
        // address previousManager = manager;
        manager = pendingManager;
        pendingManager = address(0);
        uint256 startTime = block.timestamp;
        ownershipHistory.push(Ownership({ manager: manager, startTime: startTime }));
        // emit OwnershipTransferred(previousManager, manager, startTime);

        nextPATO(orgAddress, manager);
    }

    function nextPATO(
        address _organizationAddress,
        address _manager
    ) private {
        organizationToProductAtOrganization[_organizationAddress] = PATOFactory(patoFactoryAddr).deploy(address(this), _organizationAddress, _manager);
    }

    // function getAllMyOrganizationEvents(address organization) public view returns (ProductAtOrganization.EventInfo[] memory) {
    //     // require(ownerToOrganization[msg.sender] == organization, "Only the organization can query its events");
    //     ProductAtOrganization prodAtOrg = ProductAtOrganization(organizationToProductAtOrganization[organization]);
    //     return prodAtOrg.getEvents();
    // }

    function getOwnershipHistory() public view returns (Ownership[] memory) {
        return ownershipHistory;
    }
}

contract PATOFactory {
    function deploy(
        address _productAddr,
        address  _orgAddr, 
        address _manager
    ) external returns (address) {
        return address(
            new ProductAtOrganization(
                _productAddr,
                _orgAddr,
                _manager
            )
        );
    }
}




    // // OFF-CHAIN
    // function getAllMyPermissedEvents(address organization) public view returns (OrganizationEvents[] memory) {
    //     // Verificar se o chamador tem permissão para consultar eventos da organização
    //     // require(ownerToOrganization[msg.sender] == organization, "Only the organization can query its events");

    //     //Criação do array de OrganizationEvents dinamicamente baseado na quantidade de organizacoes com permissoes para leitura
    //     int256 permittedOrgCount = 0;
    //     for (int256 i = 0; i < ProductPermissions.orgAddresses.length; i++) {
    //         address otherOrg = ProductPermissions.orgAddresses[i];
    //         if (ProductPermissions.permissionsMatrix[organization][otherOrg] > 0) {
    //             permittedOrgCount++;
    //         }
    //     }

    //     OrganizationEvents[] memory permittedEventsList = new OrganizationEvents[](permittedOrgCount);

    //     int256 currentIndex = 0;
    //     for (int256 i = 0; i < ProductPermissions.orgAddresses.length; i++) {
    //         address otherOrg = ProductPermissions.orgAddresses[i];

    //         if (ProductPermissions.permissionsMatrix[organization][otherOrg] > 0) {
    //             ProductAtOrganization prodAtOrg = ProductAtOrganization(organizationToProductAtOrganization[otherOrg]);
    //             ProductAtOrganization.EventInfo[] memory orgEvents = prodAtOrg.getEvents();

    //             permittedEventsList[currentIndex].organization = otherOrg;
    //             permittedEventsList[currentIndex].events = orgEvents;
    //             currentIndex++;
    //         }
    //     }

    //     return permittedEventsList;
    // }