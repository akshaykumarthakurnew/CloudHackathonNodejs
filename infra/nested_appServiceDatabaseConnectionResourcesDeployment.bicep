param resourceId_Microsoft_Web_sites_parameters_name string
param resourceId_Microsoft_DocumentDB_databaseAccounts_mongodbDatabases_parameters_accountName_parameters_databaseName string
param variables_serviceConnectorApiVersion ? /* TODO: fill in correct type */
param variables_serviceConnectorName ? /* TODO: fill in correct type */

resource variables_serviceConnector 'Microsoft.ServiceLinker/linkers@[parameters(\'variables_serviceConnectorApiVersion\')]' = {
  scope: resourceId_Microsoft_Web_sites_parameters_name
  name: variables_serviceConnectorName
  properties: {
    targetService: {
      type: 'AzureResource'
      id: resourceId_Microsoft_DocumentDB_databaseAccounts_mongodbDatabases_parameters_accountName_parameters_databaseName
    }
    authInfo: {
      authType: 'secret'
    }
    clientType: 'none'
    vNetSolution: {
      type: 'privateLink'
    }
  }
}