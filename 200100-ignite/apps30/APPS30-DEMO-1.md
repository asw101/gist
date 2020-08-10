# APPS30-DEMO-1

See: <https://github.com/asw101/ignite-learning-paths-training-apps/tree/master/apps30>

## set subscription
```bash
SUBSCRIPTION='ca-aawislan-demo-test'
az account set --subscription $SUBSCRIPTION
az account show
```

## create-db.sh
```bash
# variables
RESOURCE_GROUP='200100-ignite-apps30'
LOCATION='eastus'
SQL_SERVER_NAME='sql200101'
SQL_DB_NAME='tailwind'
SQL_USER='username'
SQL_PASSWORD=$(openssl rand -hex 12)'A1!'
COSMOS_NAME='cosmos200101'

# resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# cosmos db
az cosmosdb create --name $COSMOS_NAME --resource-group $RESOURCE_GROUP --kind MongoDB

COSMOS_CONNECTION_STRING=$(az cosmosdb list-connection-strings --name $COSMOS_NAME --resource-group $RESOURCE_GROUP --query 'connectionStrings[0].connectionString' -o tsv)

# azure sql
az sql server create --resource-group $RESOURCE_GROUP --location $LOCATION --name $SQL_SERVER_NAME --admin-user $SQL_USER --admin-password $SQL_PASSWORD

az sql server firewall-rule create --resource-group $RESOURCE_GROUP --server $SQL_SERVER_NAME --name azure --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# az sql db delete --resource-group $RESOURCE_GROUP --server $SQL_SERVER_NAME --name $SQL_DB_NAME
az sql db create --resource-group $RESOURCE_GROUP --server $SQL_SERVER_NAME --name $SQL_DB_NAME --family Gen4 --capacity 1

SQL_CONNECTION_STRING=$(az sql db show-connection-string --server $SQL_SERVER_NAME --name $SQL_DB_NAME -c ado.net -o tsv)

# output results
echo $COSMOS_CONNECTION_STRING
echo $SQL_CONNECTION_STRING
```

## example-notes.txt
```bash
# variables
RESOURCE_GROUP='200100-ignite-apps30'
LOCATION='eastus'
VNET_NAME="${RESOURCE_GROUP}-vnet1"
APPSERVICE_NAME="appservice200101"
RANDOM_STR=''
if [ -z "$RANDOM_STR" ]; then RANDOM_STR=$(openssl rand -hex 3); else echo $RANDOM_STR; fi
REGISTRY_NAME="acr${RANDOM_STR}"
IMAGE_NAME='twtapp:v1'

# resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# virtual network
az network vnet create -g $RESOURCE_GROUP --name $VNET_NAME --subnet-name default

# app service
az appservice plan create -g $RESOURCE_GROUP --name $APPSERVICE_NAME --sku B1 --is-linux

# container registry
az acr create -g $RESOURCE_GROUP -l $LOCATION --name $REGISTRY_NAME --sku Basic --admin-enabled

# anthonychu/TailwindTraders-Website
mkdir apps30/
git clone https://github.com/anthonychu/TailwindTraders-Website.git apps30/ 
cd apps30/Source/Tailwind.Traders.Web
git checkout monolith 

# acr build
az acr build --registry $REGISTRY_NAME --image $IMAGE_NAME .
```

## app settings
```bash
# variables
RESOURCE_GROUP='200100-ignite-apps30'
SQL_SERVER_NAME='sql200101'
SQL_DB_NAME='tailwind'
COSMOS_NAME='cosmos200101'
APP_NAME='tailwind200101' # manually set

# sql server
# we can't change the admin user, but if we don't know it, we can get it
SQL_USER=$(az sql server show --resource-group $RESOURCE_GROUP --name $SQL_SERVER_NAME | jq -r '.administratorLogin')
# let's generate a new password
SQL_PASSWORD=$(openssl rand -hex 12)'A1!'
# set the new password
az sql server update --resource-group $RESOURCE_GROUP --name $SQL_SERVER_NAME --admin-password $SQL_PASSWORD
# get the connection string and sed the values into it
SQL_CONNECTION_STRING=$(az sql db show-connection-string --server $SQL_SERVER_NAME --name $SQL_DB_NAME -c ado.net | jq -r . | sed 's/<username>/'$SQL_USER'/' | sed 's/<password>/'$SQL_PASSWORD'/')
# (optional) output the connection string
# echo $SQL_CONNECTION_STRING

# cosmos db
COSMOS_CONNECTION_STRING=$(az cosmosdb list-connection-strings --resource-group $RESOURCE_GROUP --name $COSMOS_NAME | jq -r '.connectionStrings[0].connectionString')
# (optional) output the connection string
# echo $COSMOS_CONNECTION_STRING

# hard-coded values
API_URL='/api/v1'
API_URL_SHOPPING_CART='/api/v1'
PRODUCT_IMAGES_URL='https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail'

# set appsettings
az webapp config appsettings set -g $RESOURCE_GROUP -n $APP_NAME --settings \
    apiUrl=$API_URL \
    ApiUrlShoppingCart=$API_URL_SHOPPING_CART \
    productImagesUrl=$PRODUCT_IMAGES_URL \
    MongoConnectionString=$COSMOS_CONNECTION_STRING \
    SqlConnectionString=$SQL_CONNECTION_STRING

APP_HOSTNAME=$(az webapp show -g $RESOURCE_GROUP -n $APP_NAME | jq -r .defaultHostName)
echo "https://${APP_HOSTNAME}"
```
