// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./ProductPermissions.sol";
// import "./ProductMonitor.sol";
import "./Product.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

contract ProductAtOrganization is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;
    using Strings for address;
    uint256 constant private ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10;

    struct Info {
        address organizationAddress;
        address productAddress;
        string urlMonitor;
        string PoolingJobId;
        bool IsPipelineEnabled;
    }

    struct EventInfo {
        string hashEvent;
        string timeEvent;
        string typeEvent;
    }

    EventInfo[] events;

    Info productInfo;

    address public manager;

    ProductPermissions public permissions;

    constructor(
        //TODO: urlPath
        address _productAddress,
        address _organizationAddress,
        address _manager
    ) ConfirmedOwner(msg.sender) {
        manager = _manager;
        productInfo.productAddress = _productAddress;
        productInfo.organizationAddress = _organizationAddress;
        productInfo.IsPipelineEnabled = false;
        // jobId = "d799281748b1494a8482dce72f86b72d";
        _setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        _setChainlinkOracle(0xB3B1C0B011ED2aECBc058D945FA1fF4e55b14779);
    }

    //TODO: Habilitar novo jobPipelie no novo PATO da atual organização, 
    // utilzar supplyChainId para oracle chainlink

    function EnablePipeline(
        string memory url,
        bytes32 createPipelineJobId
    ) public {
        productInfo.IsPipelineEnabled = true;
        productInfo.urlMonitor = url;

        // Product product = Product(productInfo.productAddress);       
        // ProductMonitor.createProductPipeline(productInfo.productAddress, product.getName(), productInfo.organizationAddress, createPipelineJobId);
     
        // string memory productAddressStr = Strings.toHexString(uint256(uint160(productInfo.productAddress)), 20);
        // string memory orgAddressStr = Strings.toHexString(uint256(uint160(productInfo.organizationAddress)), 20);

        //Creating a new pipeline product
        Chainlink.Request memory req = _buildChainlinkRequest(createPipelineJobId, address(this), this.fulfill.selector);
        req._add("product", "0x54243987fEB67DC2a1f6A65D95A03a6fDa29f483");
        req._add("job", "CARRO1");
        req._add("company", "0x154a9566b1695c90c281a748B734946043E35C68");

        req._addInt("times", 100);
        _sendChainlinkRequest(req, ORACLE_PAYMENT);
    }

    function getInfo() public view returns (Info memory) {
        return productInfo;
    }

    function addEvent(string memory _timeEvent, string memory _typeEvent, string memory _hashIpfs) public {
        
        EventInfo memory eventInfo = EventInfo({
            hashEvent: _hashIpfs,
            timeEvent: _timeEvent,
            typeEvent: _typeEvent
        });

        events.push(eventInfo);
    }

    function getEvents() public view returns (EventInfo[] memory){

        // checar product permissions se organizacao/msg.sender pode consumir esses eventos
        return events;
    }

    function setPoolingJobId(string memory _poolingJobId) public {
        productInfo.PoolingJobId = _poolingJobId;
    }

        event RequestDataFullFilled(
        bytes32 indexed requestId,
        bytes indexed data,
        address productAddress
    );

    function fulfill(bytes32 _requestId, bytes memory _data, address _productAddress)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDataFullFilled(_requestId, _data, _productAddress);
        ProductAtOrganization productAtOrg = ProductAtOrganization(_productAddress);
        productAtOrg.setPoolingJobId(string(_data));
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(_chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
