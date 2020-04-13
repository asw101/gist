# README

curl + bash

```bash
export RESOURCE_GROUP='200400-hello-world'
curl https://raw.githubusercontent.com/asw101/gist/cdd2e3e3a50264e468d5bbf9e70d458d1e95628e/200400-az-sp-rg/CREATE-SP-RG.sh | bash
```

source + curl

```bash
RESOURCE_GROUP='200400-hello-world'
source <(curl -s https://raw.githubusercontent.com/asw101/gist/cdd2e3e3a50264e468d5bbf9e70d458d1e95628e/200400-az-sp-rg/CREATE-SP-RG.sh)
```
