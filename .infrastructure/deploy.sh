# repositoryUrl=$(gh repo view --json url -q ".url")
uuidConcat=$(openssl rand -hex 16)
deploymentName=$(echo ${uuidConcat:0:8}-${uuidConcat:8:4}-${uuidConcat:12:4}-${uuidConcat:16:4}-${uuidConcat:20:12})

az deployment sub create -f .infrastructure/main.bicep -l westeurope -n $deploymentName
webAppName=$(az deployment sub show -n $deploymentName --query properties.outputs.staticWebAppName.value -o tsv)
deploymentToken=$(az staticwebapp secrets list -n $webAppName --q "properties.apiKey" -o tsv)

# doesn't work, needs to be created manually for now!
echo Please add this token as GitHub secret AZURE_STATIC_WEB_APPS_API_TOKEN: $deploymentToken
gh secret set AZURE_STATIC_WEB_APPS_API_TOKEN --body "$deploymentToken"