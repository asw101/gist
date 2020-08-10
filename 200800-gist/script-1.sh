#!/usr/bin/env bash

function create_azure_files_moodle_share
{
    local storageAccountName=$1
    local storageAccountKey=$2
    local logFilePath=$3
    local fileServerDiskSize=$4

    az storage share create \
        --name moodle \
        --account-name $storageAccountName \
        --account-key $storageAccountKey \
        --fail-on-exist >>$logFilePath \
        --quota $fileServerDiskSize
}

function setup_and_mount_azure_files_moodle_share
{
    local storageAccountName=$1
    local storageAccountKey=$2

    cat <<EOF > /etc/moodle_azure_files.credential
username=$storageAccountName
password=$storageAccountKey
EOF
    chmod 600 /etc/moodle_azure_files.credential
    
    grep -q -s "^//$storageAccountName.file.core.windows.net/moodle\s\s*/moodle\s\s*cifs" /etc/fstab && _RET=$? || _RET=$?
    if [ $_RET != "0" ]; then
        echo -e "\n//$storageAccountName.file.core.windows.net/moodle   /moodle cifs    credentials=/etc/moodle_azure_files.credential,uid=www-data,gid=www-data,nofail,vers=3.0,dir_mode=0770,file_mode=0660,serverino,mfsymlinks" >> /etc/fstab
    fi
    mkdir -p /moodle
    mount /moodle
}

# Delayed copy of moodle installation to the Azure Files share

# First rename moodle directory to something else
mv /moodle /moodle_old_delete_me
# Then create the moodle share
echo -e '\n\rCreating an Azure Files share for moodle'
create_azure_files_moodle_share $storageAccountName $storageAccountKey /tmp/wabs.log $fileServerDiskSize
# Set up and mount Azure Files share. Must be done after nginx is installed because of www-data user/group
echo -e '\n\rSetting up and mounting Azure Files share on //'$storageAccountName'.file.core.windows.net/moodle on /moodle\n\r'
setup_and_mount_azure_files_moodle_share $storageAccountName $storageAccountKey
# Move the local installation over to the Azure Files
echo -e '\n\rMoving locally installed moodle over to Azure Files'
cp -a /moodle_old_delete_me/* /moodle || true # Ignore case sensitive directory copy failure
rm -rf /moodle_old_delete_me || true # Keep the files just in case
