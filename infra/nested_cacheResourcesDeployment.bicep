param resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet string
param resourceId_Microsoft_Cache_Redis_parameters_cacheName string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForCache string
param resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForCache string
param variables_privateEndpointApiVersion ? /* TODO: fill in correct type */
param variables_cacheApiVersion ? /* TODO: fill in correct type */
param privateEndpointNameForCache string
param location string
param cacheName string

resource privateEndpointNameForCache_resource 'Microsoft.Network/privateEndpoints@[parameters(\'variables_privateEndpointApiVersion\')]' = {
  name: privateEndpointNameForCache
  location: location
  properties: {
    subnet: {
      id: resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointNameForCache
        properties: {
          privateLinkServiceId: resourceId_Microsoft_Cache_Redis_parameters_cacheName
          groupIds: [
            'redisCache'
          ]
        }
      }
    ]
  }
  dependsOn: [
    cache
  ]
}

resource privateEndpointNameForCache_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@[parameters(\'variables_privateEndpointApiVersion\')]' = {
  name: '${privateEndpointNameForCache}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-redis-cache-windows-net'
        properties: {
          privateDnsZoneId: resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForCache
        }
      }
    ]
  }
  dependsOn: [
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForCache
  ]
}

resource cache 'Microsoft.Cache/Redis@[parameters(\'variables_cacheApiVersion\')]' = {
  name: cacheName
  location: location
  tags: {}
  properties: {
    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 0
    }
    redisConfiguration: {}
    enableNonSslPort: false
    redisVersion: '6'
    publicNetworkAccess: 'Disabled'
  }
}