// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "./Organization.sol";
import "./Product.sol";
import "./ParticipationManager.sol";

contract SupplyChain {

    int256 public supplyChainId;
    string public productType;
    address public tokenLink;

    address[] public deployedProducts;

    address participationManagerAddress;

    event ProductCreated(address indexed contractAddress);

    constructor(
        address[] memory _possibleOrganizations,
        address _tokenLink, 
        int256 _supplyChainId,
        string memory _productType
    )
    {   
        tokenLink = _tokenLink;
        supplyChainId = _supplyChainId;
        productType = _productType;
        
        participationManagerAddress = address(new ParticipationManager(_possibleOrganizations));
    }


    function acceptParticipation(address orgAddress) public  {
        ParticipationManager participationManager = ParticipationManager(participationManagerAddress);
        participationManager.acceptParticipation(orgAddress);
    }

    // function getProducts() public view returns (address[] memory) {
    //     return deployedProducts;
    // }

    function NewProduct(
        string memory _productName, 
        string memory _productId, 
        address _organizationAddress
    ) public {
        ParticipationManager participationManager = ParticipationManager(participationManagerAddress);
        // require(ParticipationManager.addressInOrgAddresses(_organizationAddress), "Organization is not in SupplyChain");
        require(participationManager.GetIsReady(), "All organizations needs to accept");
        // Organization org = Organization(_organizationAddress);
        // require(Organization(_organizationAddress).IsOwner(), "Only owner can accept the participation");
        // require(defaultPermissions[0].length == manager.GetOrganizations().length, "Only owner can accept the participation");

        address newProduct = address(new Product(
                _productName,
                _productId,
                _organizationAddress, 
                participationManager.GetOrganizations()
            )
        );

        deployedProducts.push(address(newProduct));
        emit ProductCreated(address(newProduct));
    }

    // function getAllowedOrgs(address orgAddress, string memory productId) public view returns (address[] memory) {
    //     // RootSupplyChain rsChain = RootSupplyChain(rootSupplyChain);

    //     // address organizationAddress = rsChain.getMyOrganization();
    //     // require(!ParticipationManager.addressInArrayAddress(organizationAddress, ParticipationManager.organizations), "Organization is not in SupplyChain");

        
    //     Product product = Product(IdToProduct[productId]);
    //     // Product.OrganizationEvents[] memory events = product.getAllMyPermissedEvents(organizationAddress);

    //     return product.getAllMyPermissedOrgs(orgAddress);
    // }

}


// contract ProductFactory {
//     function deployProduct(
//         string memory _productName,
//         string memory _productId, 
//         address _organizationAddress,
//         address[] memory _participationsAddress
//     ) external returns (address) {
//         return address(
//             new Product(
//                 _productName,
//                 _productId,
//                 _organizationAddress, 
//                 _participationsAddress
//             )
//         );
//     }
// }

// http://200.137.66.30:8082/api/companies/1/objects/
// jobId = "d799281748b1494a8482dce72f86b72d";
// setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
// setChainlinkOracle(0xB3B1C0B011ED2aECBc058D945FA1fF4e55b14779);

    // function getDeployedProducts() public view returns (address[] memory) {
    //     return deployedProducts;
    // }

    // function getAllEvents(string memory productId) public view returns (Product.OrganizationEvents[] memory) {
    //     RootSupplyChain rsChain = RootSupplyChain(rootSupplyChain);

    //     address organizationAddress = rsChain.getMyOrganization();
    //     require(!ParticipationManager.addressInArrayAddress(organizationAddress, ParticipationManager.organizations), "Organization is not in SupplyChain");

    //     Product product = Product(IdToProduct[productId]);
    //     Product.OrganizationEvents[] memory events = product.getAllMyPermissedEvents(organizationAddress);

    //     return events;
    // }