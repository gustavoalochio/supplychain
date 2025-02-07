// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "./ProductAtOrganization.sol";
// import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
// import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

// //TODO: ADicionar ao product ou pato, para criar chainlink jobs
// abstract contract ProductMonitor is ChainlinkClient, ConfirmedOwner {
//     using Chainlink for Chainlink.Request;
//     using Strings for address;
//     uint256 constant private ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10;

//     constructor() ConfirmedOwner(msg.sender) {}

//     function createProductPipeline(
//         address _productAddress, 
//         string memory _productName, 
//         address  _organizationAddress,
//         bytes32 _CreatePipelineJobId
//     ) public {
//         // ProductAtOrganization productAtOrg = ProductAtOrganization(_productAddress);

//         string memory productAddressStr = Strings.toHexString(uint256(uint160(_productAddress)), 20);
//         string memory orgAddressStr = Strings.toHexString(uint256(uint160(_organizationAddress)), 20);

//         //Creating a new pipeline product
//         Chainlink.Request memory req = _buildChainlinkRequest(_CreatePipelineJobId, address(this), this.fulfill.selector);
//         req._add("product", productAddressStr);
//         req._add("job", _productName);
//         req._add("company", orgAddressStr);

//         req._addInt("times", 100);
//         _sendChainlinkRequest(req, ORACLE_PAYMENT);
//     }

//     event RequestDataFullFilled(
//         bytes32 indexed requestId,
//         bytes indexed data,
//         address productAddress
//     );

//     function fulfill(bytes32 _requestId, bytes memory _data, address _productAddress)
//         public
//         recordChainlinkFulfillment(_requestId)
//     {
//         emit RequestDataFullFilled(_requestId, _data, _productAddress);
//         ProductAtOrganization productAtOrg = ProductAtOrganization(_productAddress);
//         productAtOrg.setPoolingJobId(string(_data));
//     }

//     function withdrawLink() public onlyOwner {
//         LinkTokenInterface link = LinkTokenInterface(_chainlinkTokenAddress());
//         require(
//             link.transfer(msg.sender, link.balanceOf(address(this))),
//             "Unable to transfer"
//         );
//     }

//     function toBytes32(string memory source) public pure returns (bytes32 result) {
//         require(bytes(source).length <= 32, "String too long");

//         assembly {
//             result := mload(add(source, 32))
//         }
//     }
// }
