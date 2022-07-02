# README

```bash
# show only my apps
az ad app list --show-mine | jq -r '.[].displayName' | sort

# output all to file
az ad app list --show-mine | jq -r '.[].displayName' | sort > az-ad-app-list.txt

# create loop-delete.sh
while read DISPLAY_NAME;
do
    echo "$DISPLAY_NAME"
    OBJECT_ID=$(az ad app list \
    --filter "displayname eq '"$DISPLAY_NAME"'" \
    --query '[0].id' \
    --out tsv)
    az ad app delete --id $OBJECT_ID
done

# copy selected ids to input.txt

# delete from input.txt
cat input.txt | bash loop-delete.sh
```
