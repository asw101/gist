#!/usr/bin/env bash

git clone -b asw101-dev https://github.com/asw101/Moodle
cd /home/azureadmin/Moodle/scripts/
apt-get update && apt-get install -y moreutils

# setup_webserver
bash setup_webserver.sh /home/azureadmin/env.json 2>&1 | ts '%Y%m%d-%H:%M:%S' | tee setup_webserver.log
