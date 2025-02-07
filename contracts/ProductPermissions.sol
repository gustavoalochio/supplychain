// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./ParticipationManager.sol";

abstract contract ProductPermissions {
    
    address[] public orgAddresses;
    mapping(address => mapping(address => int)) public permissionsMatrix;

    // address public owner;
    event PermissionChanged(address indexed org1, address indexed org2, int256 permission);

    constructor(address[] memory _orgAddresses) {

        // owner = _owner;
        // require(initialPermissions[0].length == 4, "Ta.");

        // require(_orgAddresses.length == initialPermissions[0].length, "Tamanho das organizacoes e permissoes nao corresponde.");
        for (uint256 i = 0; i < _orgAddresses.length; i++) {
            // require(initialPermissions[i].length == _orgAddresses.length, "Permissoes deve ser uma matriz quadrada.");
            for (uint256 j = 0; j < _orgAddresses.length; j++) {
                permissionsMatrix[_orgAddresses[i]][_orgAddresses[j]] = 1;
            }
        }
    }

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "Acesso restrito ao owner.");
    //     _;
    // }

    function setPermission(address org1, address org2, int256 permission) public {
        require(permission == 0 || permission == 1, "Permissao deve ser 0 ou 1.");
        permissionsMatrix[org1][org2] = permission;
        emit PermissionChanged(org1, org2, permission);
    }

    function hasPermission(address org1, address org2) public view returns (bool) {
        return permissionsMatrix[org1][org2] == 1;
    }

    function getAllMyPermissedOrgs(address organizationAddr) public view returns (address[] memory) {
        // Verificar se o chamador tem permissão para consultar eventos da organização
        // require(ownerToOrganization[msg.sender] == organization, "Only the organization can query its events");

        //Criação do array de OrganizationEvents dinamicamente baseado na quantidade de organizacoes com permissoes para leitura
        uint256 permittedOrgCount = 0;
        for (uint256 i = 0; i < ProductPermissions.orgAddresses.length; i++) {
            address otherOrg = ProductPermissions.orgAddresses[i];
            if (ProductPermissions.permissionsMatrix[organizationAddr][otherOrg] > 0) {
                permittedOrgCount++;
            }
        }

        address[] memory permittedOrgList = new address[](permittedOrgCount);

        uint256 currentIndex = 0;
        for (uint256 i = 0; i < ProductPermissions.orgAddresses.length; i++) {
            address otherOrg = ProductPermissions.orgAddresses[i];

            if (ProductPermissions.permissionsMatrix[organizationAddr][otherOrg] > 0) {
                permittedOrgList[currentIndex] = otherOrg;
                currentIndex++;
            }
        }

        return permittedOrgList;
    }
}