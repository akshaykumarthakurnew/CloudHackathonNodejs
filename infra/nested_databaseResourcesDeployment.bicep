param resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet string
param resourceId_Microsoft_DocumentDb_databaseAccounts_parameters_accountName string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb string
param resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForDb string
param variables_resourcesDeploymentApiVersion ? /* TODO: fill in correct type */
param variables_databaseResourcesDeployment ? /* TODO: fill in correct type */
param variables_privateEndpointApiVersion ? /* TODO: fill in correct type */
param variables_databaseApiVersion ? /* TODO: fill in correct type */
param variables_databaseVersion ? /* TODO: fill in correct type */
param isVnetEnabled bool
param privateEndpointNameForDb string
param location string
param accountName string
param defaultExperience string
param databaseAccountType string
param backupPolicyType string
param backupIntervalInMinutes int
param backupRetentionIntervalInHours int
param backupStorageRedundancy string
param isVirtualNetworkFilterEnabled string
param capabilities array
param enableFreeTier string
param databaseName string

module variables_databaseResourcesDeployment_vnet './nested_variables_databaseResourcesDeployment_vnet.bicep' = if (isVnetEnabled) {
  name: '${variables_databaseResourcesDeployment}-vnet'
  params: {
    variables_privateEndpointApiVersion: variables_privateEndpointApiVersion
    privateEndpointNameForDb: privateEndpointNameForDb
    location: location
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet: resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet
    resourceId_Microsoft_DocumentDb_databaseAccounts_parameters_accountName: resourceId_Microsoft_DocumentDb_databaseAccounts_parameters_accountName
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb: resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForDb: resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForDb
  }
  dependsOn: [
    account
  ]
}

resource account 'Microsoft.DocumentDB/databaseAccounts@[parameters(\'variables_databaseApiVersion\')]' = {
  location: location
  name: accountName
  kind: 'MongoDB'
  tags: {
    deployment: 'poc'
    'hidden-cosmos-mmspecial': ''
    defaultExperience: defaultExperience
  }
  properties: {
    databaseAccountOfferType: databaseAccountType
    locations: [
      {
        failoverPriority: 0
        locationName: location
      }
    ]
    backupPolicy: {
      type: backupPolicyType
      periodicModeProperties: {
        backupIntervalInMinutes: backupIntervalInMinutes
        backupRetentionIntervalInHours: backupRetentionIntervalInHours
        backupStorageRedundancy: backupStorageRedundancy
      }
    }
    isVirtualNetworkFilterEnabled: isVirtualNetworkFilterEnabled
    virtualNetworkRules: []
    ipRules: []
    dependsOn: []
    capabilities: capabilities
    apiProperties: {
      serverVersion: variables_databaseVersion
    }
    enableFreeTier: enableFreeTier
  }
}

resource accountName_database 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@[parameters(\'variables_databaseApiVersion\')]' = {
  name: '${accountName}/${databaseName}'
  properties: {
    resource: {
      id: databaseName
    }
  }
  dependsOn: [
    account
  ]
}