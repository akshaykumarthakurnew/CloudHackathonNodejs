param resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForCache string
param variables_vnetDeploymentApiVersion ? /* TODO: fill in correct type */
param variables_vnetAddress ? /* TODO: fill in correct type */
param variables_subnetAddressForPrivateEndpoint ? /* TODO: fill in correct type */
param variables_privateDnsApiVersion ? /* TODO: fill in correct type */
param location string
param vnetName string
param privateEndpointSubnet string
param isPrivateEndpointForAppEnabled bool
param privateDnsZoneNameForApp string
param privateDnsZoneNameForDb string
param privateDnsZoneNameForCache string

resource vnet 'Microsoft.Network/virtualNetworks@[parameters(\'variables_vnetDeploymentApiVersion\')]' = {
  location: location
  name: vnetName
  properties: {
    addressSpace: {
      addressPrefixes: [
        variables_vnetAddress
      ]
    }
    subnets: []
  }
}

resource vnetName_privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@[parameters(\'variables_vnetDeploymentApiVersion\')]' = {
  name: '${vnetName}/${privateEndpointSubnet}'
  properties: {
    delegations: []
    serviceEndpoints: []
    addressPrefix: variables_subnetAddressForPrivateEndpoint
    privateEndpointNetworkPolicies: 'Disabled'
  }
  dependsOn: [
    resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName
  ]
}

resource privateDnsZoneNameForApp_resource 'Microsoft.Network/privateDnsZones@[parameters(\'variables_privateDnsApiVersion\')]' = if (isPrivateEndpointForAppEnabled) {
  name: privateDnsZoneNameForApp
  location: 'global'
}

resource privateDnsZoneNameForApp_privateDnsZoneNameForApp_applink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@[parameters(\'variables_privateDnsApiVersion\')]' = if (isPrivateEndpointForAppEnabled) {
  name: '${privateDnsZoneNameForApp}/${privateDnsZoneNameForApp}-applink'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName
    }
    registrationEnabled: false
  }
  dependsOn: [
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp
  ]
}

resource privateDnsZoneNameForDb_resource 'Microsoft.Network/privateDnsZones@[parameters(\'variables_privateDnsApiVersion\')]' = {
  name: privateDnsZoneNameForDb
  location: 'global'
}

resource privateDnsZoneNameForDb_privateDnsZoneNameForDb_dblink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@[parameters(\'variables_privateDnsApiVersion\')]' = {
  name: '${privateDnsZoneNameForDb}/${privateDnsZoneNameForDb}-dblink'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName
    }
    registrationEnabled: false
  }
  dependsOn: [
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb
  ]
}

resource privateDnsZoneNameForCache_resource 'Microsoft.Network/privateDnsZones@[parameters(\'variables_privateDnsApiVersion\')]' = {
  name: privateDnsZoneNameForCache
  location: 'global'
}

resource privateDnsZoneNameForCache_privateDnsZoneNameForCache_applink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@[parameters(\'variables_privateDnsApiVersion\')]' = {
  name: '${privateDnsZoneNameForCache}/${privateDnsZoneNameForCache}-applink'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName
    }
    registrationEnabled: false
  }
  dependsOn: [
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForCache
  ]
}