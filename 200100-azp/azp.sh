azp() {
    TMP=''
    if [ ! -z "$1" ] 
    then
        TMP=$1
    fi
    if [ ! -z "$RESOURCE_GROUP" ] 
    then
        TMP=$RESOURCE_GROUP
    fi
    if [ -z "$TMP" ] 
    then
        echo "No parameter passed and RESOURCE_GROUP not set."
        return 1
    fi
    ACCOUNT=$(az account show)
    SUBSCRIPTION_ID=$(echo $ACCOUNT | jq -r .id)
    TENANT_ID=$(echo $ACCOUNT | jq -r .tenantId)
    open "https://portal.azure.com/#@${TENANT_ID}/resource/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${TMP}/overview"
}

azpi() {
    read input
    azp $input
}
