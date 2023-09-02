param variables_vnetDeploymentApiVersion ? /* TODO: fill in correct type */
param vnetName string
param subnetForApp string
param variables_subnetAddressForApp ? /* TODO: fill in correct type */
param variables_appServicesApiVersion ? /* TODO: fill in correct type */
param name string
param resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_subnetForApp string
param isPrivateEndpointForAppEnabled bool
param variables_privateEndpointApiVersion ? /* TODO: fill in correct type */
param privateEndpointNameForApp string
param location string
param resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet string
param resourceId_Microsoft_Web_Sites_parameters_name string
param privateDnsZoneNameForApp string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp string
param resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForApp string

resource vnetName_subnetForApp 'Microsoft.Network/virtualNetworks/subnets@[parameters(\'variables_vnetDeploymentApiVersion\')]' = {
  name: '${vnetName}/${subnetForApp}'
  properties: {
    delegations: [
      {
        name: 'dlg-appServices'
        properties: {
          serviceName: 'Microsoft.Web/serverfarms'
        }
      }
    ]
    serviceEndpoints: []
    addressPrefix: variables_subnetAddressForApp
  }
}

resource name_virtualNetwork 'Microsoft.Web/sites/networkConfig@[parameters(\'variables_appServicesApiVersion\')]' = {
  name: '${name}/virtualNetwork'
  properties: {
    subnetResourceId: resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_subnetForApp
  }
  dependsOn: [
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_subnetForApp
  ]
}

resource privateEndpointNameForApp_resource 'Microsoft.Network/privateEndpoints@[parameters(\'variables_privateEndpointApiVersion\')]' = if (isPrivateEndpointForAppEnabled) {
  name: privateEndpointNameForApp
  location: location
  properties: {
    subnet: {
      id: resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointNameForApp
        properties: {
          privateLinkServiceId: resourceId_Microsoft_Web_Sites_parameters_name
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}

resource privateEndpointNameForApp_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@[parameters(\'variables_privateEndpointApiVersion\')]' = if (isPrivateEndpointForAppEnabled) {
  name: '${privateEndpointNameForApp}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneNameForApp
        properties: {
          privateDnsZoneId: resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp
        }
      }
    ]
  }
  dependsOn: [
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForApp
  ]
}