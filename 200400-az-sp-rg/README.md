# README

curl + bash

```bash
export RESOURCE_GROUP='200400-hello-world'
curl https://raw.githubusercontent.com/asw101/gist/master/200400-az-sp-rg/CREATE-SP-RG.sh | bash
```

source + curl

```bash
RESOURCE_GROUP='200400-hello-world'
source <(curl -s https://raw.githubusercontent.com/asw101/gist/master/200400-az-sp-rg/CREATE-SP-RG.sh)
```
