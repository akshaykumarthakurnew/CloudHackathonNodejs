param resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_subnetForApp string
param resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet string
param resourceId_Microsoft_Web_Sites_parameters_name string
param resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp string
param resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForApp string
param resourceId_Microsoft_Web_serverfarms_parameters_hostingPlanName string
param variables_appServicesApiVersion ? /* TODO: fill in correct type */
param variables_resourcesDeploymentApiVersion ? /* TODO: fill in correct type */
param variables_appServiceResourcesDeployment ? /* TODO: fill in correct type */
param variables_vnetDeploymentApiVersion ? /* TODO: fill in correct type */
param variables_subnetAddressForApp ? /* TODO: fill in correct type */
param variables_privateEndpointApiVersion ? /* TODO: fill in correct type */
param hostingPlanName string
param location string
param workerSize string
param workerSizeId string
param numberOfWorkers string
param sku string
param skuCode string
param name string
param linuxFxVersion string
param ftpsState string
param subscriptionId string
param serverFarmResourceGroup string
param isVnetEnabled bool
param vnetName string
param subnetForApp string
param isPrivateEndpointForAppEnabled bool
param privateEndpointNameForApp string
param privateDnsZoneNameForApp string

resource hostingPlan 'Microsoft.Web/serverfarms@[parameters(\'variables_appServicesApiVersion\')]' = {
  name: hostingPlanName
  location: location
  kind: 'linux'
  tags: {
    deployment: 'poc'
  }
  properties: {
    name: hostingPlanName
    workerSize: workerSize
    workerSizeId: workerSizeId
    numberOfWorkers: numberOfWorkers
    reserved: true
  }
  sku: {
    Tier: sku
    Name: skuCode
  }
}

resource name_resource 'Microsoft.Web/sites@[parameters(\'variables_appServicesApiVersion\')]' = {
  name: name
  location: location
  tags: {
    deployment: 'poc'
  }
  properties: {
    name: name
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: []
      vnetRouteAllEnabled: true
      ftpsState: ftpsState
    }
    serverFarmId: '/subscriptions/${subscriptionId}/resourcegroups/${serverFarmResourceGroup}/providers/Microsoft.Web/serverfarms/${hostingPlanName}'
    clientAffinityEnabled: false
  }
  dependsOn: [
    hostingPlan
  ]
}

module variables_appServiceResourcesDeployment_vnet './nested_variables_appServiceResourcesDeployment_vnet.bicep' = if (isVnetEnabled) {
  name: '${variables_appServiceResourcesDeployment}-vnet'
  params: {
    variables_vnetDeploymentApiVersion: variables_vnetDeploymentApiVersion
    vnetName: vnetName
    subnetForApp: subnetForApp
    variables_subnetAddressForApp: variables_subnetAddressForApp
    variables_appServicesApiVersion: variables_appServicesApiVersion
    name: name
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_subnetForApp: resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_subnetForApp
    isPrivateEndpointForAppEnabled: isPrivateEndpointForAppEnabled
    variables_privateEndpointApiVersion: variables_privateEndpointApiVersion
    privateEndpointNameForApp: privateEndpointNameForApp
    location: location
    resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet: resourceId_Microsoft_Network_virtualNetworks_subnets_parameters_vnetName_parameters_privateEndpointSubnet
    resourceId_Microsoft_Web_Sites_parameters_name: resourceId_Microsoft_Web_Sites_parameters_name
    privateDnsZoneNameForApp: privateDnsZoneNameForApp
    resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp: resourceId_Microsoft_Network_privateDnsZones_parameters_privateDnsZoneNameForApp
    resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForApp: resourceId_Microsoft_Network_privateEndpoints_parameters_privateEndpointNameForApp
  }
  dependsOn: [
    resourceId_Microsoft_Web_serverfarms_parameters_hostingPlanName
    resourceId_Microsoft_Web_Sites_parameters_name
  ]
}