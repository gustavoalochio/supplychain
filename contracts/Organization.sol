// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Organization {
    
    struct Info {
        address oracle;
        address tokenLink;
        string jobId;
        string companyName;
        string urlCompany; // www.wsg.com/api/company/:id
        bool isEnabled;
    }
    
    Info organizationInfo;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // http://200.137.66.30:8082/api/companies/1/objects/
    // jobId = "ea305d926bd44d7390d4218c728be302";
    // setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
    // setChainlinkOracle(0xB3B1C0B011ED2aECBc058D945FA1fF4e55b14779);

    constructor(
        string memory _url, 
        string memory _companyName, 
        address _tokenLink,
        address _oracle,
        string memory _jobId
    ) {
        owner = msg.sender;

        organizationInfo.urlCompany = _url;
        organizationInfo.companyName = _companyName;
        organizationInfo.tokenLink = _tokenLink;
        organizationInfo.oracle = _oracle;
        organizationInfo.jobId = _jobId;

        organizationInfo.isEnabled = true;

        // setChainlinkToken(_tokenLink);
        // setChainlinkOracle(_oracle);
    }

    function getInfo() public view returns (Info memory) {
        return organizationInfo;
    }

    function setTokenLink(address _tokenLink) public {
        organizationInfo.tokenLink = _tokenLink;
    }

    function setOracle(address _oracle) public {
        organizationInfo.oracle = _oracle;
    }

    function setJobId(string memory _jobId) public {
        organizationInfo.jobId = _jobId;
    }

    function setCompanyName(string memory _companyName) public {
        organizationInfo.companyName = _companyName;
    }

    function setUrlCompany(string memory _urlCompany) public {
        organizationInfo.urlCompany = _urlCompany;
    }

    function disable() public onlyOwner {
        organizationInfo.isEnabled = false;
    }

    function IsOwner() public view returns(bool) {
        return msg.sender == owner;
    }
}