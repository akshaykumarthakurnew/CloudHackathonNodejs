param subscriptionId string
param name string
param location string
param hostingPlanName string
param serverFarmResourceGroup string
param databaseName string
param ftpsState string
param sku string
param skuCode string
param workerSize string
param workerSizeId string
param numberOfWorkers string
param linuxFxVersion string
param accountName string
param databaseKind string
param defaultExperience string
param isZoneRedundant string
param databaseAccountType string
param backupPolicyType string
param backupIntervalInMinutes int
param backupRetentionIntervalInHours int
param backupStorageRedundancy string
param isVirtualNetworkFilterEnabled string
param enableFreeTier string
param capabilities array
param isVnetEnabled bool
param isPrivateEndpointForAppEnabled bool
param vnetName string
param privateEndpointSubnet string
param subnetForApp string
param subnetForDb string
param privateEndpointNameForApp string
param privateEndpointNameForDb string
param privateEndpointNameForCache string
param privateDnsZoneNameForApp string
param privateDnsZoneNameForDb string
param privateDnsZoneNameForCache string
param isCacheEnabled bool
param cacheName string

var vnetResourcesDeployment_var = 'vnetResourcesDeployment'
var databaseResourcesDeployment_var = 'databaseResourcesDeployment'
var cacheResourcesDeployment_var = 'cacheResourcesDeployment'
var appServiceResourcesDeployment_var = 'appServiceResourcesDeployment'
var appServiceDatabaseConnectionResourcesDeployment_var = 'appServiceDatabaseConnectionResourcesDeployment'
var resourcesDeploymentApiVersion = '2020-06-01'
var appServicesApiVersion = '2018-11-01'
var databaseApiVersion = '2021-04-15'
var databaseVersion = '4.0'
var vnetDeploymentApiVersion = '2020-07-01'
var privateDnsApiVersion = '2018-09-01'
var privateEndpointApiVersion = '2021-02-01'
var vnetAddress = '10.0.0.0/16'
var subnetAddressForPrivateEndpoint = '10.0.0.0/24'
var subnetAddressForApp = '10.0.2.0/24'
var subnetAddressForDb = '10.0.1.0/24'
var cacheApiVersion = '2022-06-01'
var serviceConnectorApiVersion = '2022-05-01'
var serviceConnectorName = 'defaultConnector'
var serviceConnectorRedisName = 'RedisConnector'

module databaseResourcesDeployment './nested_databaseResourcesDeployment.bicep' = {
  name: databaseResourcesDeployment_var
  params: {
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, privateEndpointSubnet)
    resourceId_Microsoft_DocumentDb_databaseAccounts_parameters_accountName: resourceId('Microsoft.DocumentDb/databaseAccounts/', accountName)
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb: resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameForDb)
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForDb: resourceId('Microsoft.Network/privateEndpoints', privateEndpointNameForDb)
    variables_resourcesDeploymentApiVersion: resourcesDeploymentApiVersion
    variables_databaseResourcesDeployment: databaseResourcesDeployment_var
    variables_privateEndpointApiVersion: privateEndpointApiVersion
    variables_databaseApiVersion: databaseApiVersion
    variables_databaseVersion: databaseVersion
    isVnetEnabled: isVnetEnabled
    privateEndpointNameForDb: privateEndpointNameForDb
    location: location
    accountName: accountName
    defaultExperience: defaultExperience
    databaseAccountType: databaseAccountType
    backupPolicyType: backupPolicyType
    backupIntervalInMinutes: backupIntervalInMinutes
    backupRetentionIntervalInHours: backupRetentionIntervalInHours
    backupStorageRedundancy: backupStorageRedundancy
    isVirtualNetworkFilterEnabled: isVirtualNetworkFilterEnabled
    capabilities: capabilities
    enableFreeTier: enableFreeTier
    databaseName: databaseName
  }
  dependsOn: [
    vnetResourcesDeployment
  ]
}

module cacheResourcesDeployment './nested_cacheResourcesDeployment.bicep' = if (isCacheEnabled) {
  name: cacheResourcesDeployment_var
  params: {
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, privateEndpointSubnet)
    resourceId_Microsoft_Cache_Redis_parameters_cacheName: resourceId('Microsoft.Cache/Redis/', cacheName)
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForCache: resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameForCache)
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForCache: resourceId('Microsoft.Network/privateEndpoints', privateEndpointNameForCache)
    variables_privateEndpointApiVersion: privateEndpointApiVersion
    variables_cacheApiVersion: cacheApiVersion
    privateEndpointNameForCache: privateEndpointNameForCache
    location: location
    cacheName: cacheName
  }
  dependsOn: [
    vnetResourcesDeployment
  ]
}

module appServiceResourcesDeployment './nested_appServiceResourcesDeployment.bicep' = {
  name: appServiceResourcesDeployment_var
  params: {
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_subnetForApp: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetForApp)
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, privateEndpointSubnet)
    resourceId_Microsoft_Web_Sites_parameters_name: resourceId('Microsoft.Web/Sites', name)
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp: resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameForApp)
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForApp: resourceId('Microsoft.Network/privateEndpoints', privateEndpointNameForApp)
    resourceId_Microsoft_Web_serverfarms_parameters_hostingPlanName: resourceId('Microsoft.Web/serverfarms', hostingPlanName)
    variables_appServicesApiVersion: appServicesApiVersion
    variables_resourcesDeploymentApiVersion: resourcesDeploymentApiVersion
    variables_appServiceResourcesDeployment: appServiceResourcesDeployment_var
    variables_vnetDeploymentApiVersion: vnetDeploymentApiVersion
    variables_subnetAddressForApp: subnetAddressForApp
    variables_privateEndpointApiVersion: privateEndpointApiVersion
    hostingPlanName: hostingPlanName
    location: location
    workerSize: workerSize
    workerSizeId: workerSizeId
    numberOfWorkers: numberOfWorkers
    sku: sku
    skuCode: skuCode
    name: name
    linuxFxVersion: linuxFxVersion
    ftpsState: ftpsState
    subscriptionId: subscriptionId
    serverFarmResourceGroup: serverFarmResourceGroup
    isVnetEnabled: isVnetEnabled
    vnetName: vnetName
    subnetForApp: subnetForApp
    isPrivateEndpointForAppEnabled: isPrivateEndpointForAppEnabled
    privateEndpointNameForApp: privateEndpointNameForApp
    privateDnsZoneNameForApp: privateDnsZoneNameForApp
  }
  dependsOn: [
    vnetResourcesDeployment
  ]
}

module vnetResourcesDeployment './nested_vnetResourcesDeployment.bicep' = if (isVnetEnabled) {
  name: vnetResourcesDeployment_var
  params: {
    resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp: resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameForApp)
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForDb: resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameForDb)
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForCache: resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameForCache)
    variables_vnetDeploymentApiVersion: vnetDeploymentApiVersion
    variables_vnetAddress: vnetAddress
    variables_subnetAddressForPrivateEndpoint: subnetAddressForPrivateEndpoint
    variables_privateDnsApiVersion: privateDnsApiVersion
    location: location
    vnetName: vnetName
    privateEndpointSubnet: privateEndpointSubnet
    isPrivateEndpointForAppEnabled: isPrivateEndpointForAppEnabled
    privateDnsZoneNameForApp: privateDnsZoneNameForApp
    privateDnsZoneNameForDb: privateDnsZoneNameForDb
    privateDnsZoneNameForCache: privateDnsZoneNameForCache
  }
}

module appServiceDatabaseConnectionResourcesDeployment './nested_appServiceDatabaseConnectionResourcesDeployment.bicep' = {
  name: appServiceDatabaseConnectionResourcesDeployment_var
  params: {
    resourceId_Microsoft_Web_sites_parameters_name: resourceId('Microsoft.Web/sites', name)
    resourceId_Microsoft_DocumentDB_databaseAccounts_mongodbDatabases_parameters_accountName_parameters_databaseName: resourceId('Microsoft.DocumentDB/databaseAccounts/mongodbDatabases', accountName, databaseName)
    variables_serviceConnectorApiVersion: serviceConnectorApiVersion
    variables_serviceConnectorName: serviceConnectorName
  }
  dependsOn: [
    databaseResourcesDeployment
    appServiceResourcesDeployment
  ]
}
