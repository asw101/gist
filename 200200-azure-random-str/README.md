# Azure $RANDOM_STR

A deterministic way to generate a 6 character unique suffix/prefix for things in Azure that need to be globally unique.

```bash
RESOURCE_GROUP='200200-hello-gopher'
LOCATION='eastus'
SUBSCRIPTION_ID=$(az account show | jq -r .id)
SCOPE="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}"
# RANDOM_STR='2b7222'
RANDOM_STR=$(echo -n "$SCOPE" | shasum | head -c 6)
```
