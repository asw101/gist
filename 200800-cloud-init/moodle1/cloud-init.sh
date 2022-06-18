#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

git clone -b asw101-dev https://github.com/asw101/Moodle
cd /home/azureuser/Moodle/scripts/
apt-get update && apt-get install -y moreutils

# setup_webserver
bash setup_webserver.sh /home/azureuser/env.json 2>&1 | ts '%Y%m%d-%H:%M:%S' | tee setup_webserver.log

MOODLE_SITEURL=$(cat env.json | jq -r '.siteProfile.siteURL')
sed -i "/wwwroot/c\$CFG->wwwroot = 'https://${MOODLE_SITEURL}';" /var/www/html/moodle/config.php
service nginx restart
