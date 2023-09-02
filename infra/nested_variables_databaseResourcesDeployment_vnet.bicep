param variables_privateEndpointApiVersion ? /* TODO: fill in correct type */
param privateEndpointNameForDb string
param location string
param resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet string
param resourceId_Microsoft_DocumentDb_databaseAccounts_parameters_accountName string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb string
param resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForDb string

resource privateEndpointNameForDb_resource 'Microsoft.Network/privateEndpoints@[parameters(\'variables_privateEndpointApiVersion\')]' = {
  name: privateEndpointNameForDb
  location: location
  properties: {
    subnet: {
      id: resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointNameForDb
        properties: {
          privateLinkServiceId: resourceId_Microsoft_DocumentDb_databaseAccounts_parameters_accountName
          groupIds: [
            'MongoDB'
          ]
        }
      }
    ]
  }
}

resource privateEndpointNameForDb_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@[parameters(\'variables_privateEndpointApiVersion\')]' = {
  name: '${privateEndpointNameForDb}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'database-config'
        properties: {
          privateDnsZoneId: resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb
        }
      }
    ]
  }
  dependsOn: [
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForDb
  ]
}