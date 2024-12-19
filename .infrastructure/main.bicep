targetScope = 'subscription'

param location string = 'westeurope'
// param repositoryUrl string
// param branch string = 'main'

@description('String to make resource names unique')
var resourceToken = uniqueString(subscription().subscriptionId, location)

@description('Create a resource group')
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-swa-app-${resourceToken}'
  location: location
}

@description('Create a static web app')
module swa 'br/public:avm/res/web/static-site:0.3.0' = {
  name: 'client'
  scope: rg
  params: {
    name: 'swa-${resourceToken}'
    location: location
    sku: 'Free'
  }
}

@description('Create a static web app')
resource clientApp 'Microsoft.Graph/applications@beta' = {
  uniqueName: 'app-${resourceToken}'
  displayName: 'app-${resourceToken}'
  signInAudience: 'AzureADMyOrg'
  web: {
    redirectUris: ['${swa.outputs.resource_uri}/.auth/login/aad/callback']
    implicitGrantSettings: {enableIdTokenIssuance: true}
  }
  requiredResourceAccess: [
    {
     resourceAppId: '00000003-0000-0000-c000-000000000000'
     resourceAccess: [
       // User.Read
       {id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d', type: 'Scope'}
       // offline_access
       {id: '7427e0e9-2fba-42fe-b0c0-848c9e6a8182', type: 'Scope'}
       // openid
       {id: '37f7f235-527c-4136-accd-4a02d197296e', type: 'Scope'}
       // profile
       {id: '14dad69e-099b-42c9-810b-d002981feec1', type: 'Scope'}
     ]
    }
  ]
}

resource clientSp 'Microsoft.Graph/servicePrincipals@beta' = {
  appId: clientApp.appId
}

@description('Output the default hostname')
output endpoint string = swa.outputs.defaultHostname

@description('Output the static web app name')
output staticWebAppName string = swa.outputs.name
