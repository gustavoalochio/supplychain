// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Organization.sol";

contract ParticipationManager {
    
    address[] public organizations;
    mapping(address => bool) public pendingOrganizations;
    bool hasInvites = false;
    bool IsReady = false;
    uint256 public acceptedOrganizationsCount = 0;
    uint256 public maxOrganizations;

    constructor(address[] memory _possibleOrganizations) {
        maxOrganizations = _possibleOrganizations.length;
        createInvites(_possibleOrganizations);
    }

    // function addressInOrgAddresses(address _address) public view returns (bool) {
    //     for (uint256 i = 0; i < organizations.length; i++) {
    //         if (organizations[i] == _address) {
    //             return true;
    //         }
    //     }
    //     return false;
    // }

    function createInvites(address[] memory _organizations) public {
        require(!hasInvites, "Organizations have already been invited");

        for (uint256 i = 0; i < _organizations.length; i++) {
            pendingOrganizations[_organizations[i]] = true;
        }

        hasInvites = true;
    }

    function acceptParticipation(address organization) public {
        // Organization org = Organization(organization);
        // require(org.IsOwner(), "Only owner can accept the participation");
        require(pendingOrganizations[organization], "Organization has not been invited");
        // require(!addressInOrgAddresses(organization), "Organization already accepted");

        organizations.push(organization);
        acceptedOrganizationsCount++;

        pendingOrganizations[organization] = false;

        if (acceptedOrganizationsCount == maxOrganizations) {
            IsReady = true;
        }
    }

    function allInvitesAccepted() public view returns(bool) {
        return acceptedOrganizationsCount == maxOrganizations;
    }

    function GetOrganizations()  public view returns(address[] memory) {
        return organizations;
    }
    
    function GetIsReady()  public view returns(bool) {
        return IsReady;
    }
}
