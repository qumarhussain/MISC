#!/bin/bash
source vars

tenant_id=$TENANT_ID
client_id="client_id=$CLIENT_ID"
client_secret="client_secret=$CLIENT_SECRET"
files_location=$FILES_LOCATION
file_pattern=$FILE_PATTERN
source_sharepoint_url=$SOURCE_SHAREPOINT_URL
site_name=$SITE_NAME
staging_site_url=$SOURCE_SHAREPOINT_URL
staging_dir=$STAGING_DIR

grant_type="grant_type=client_credentials"
scope="scope=https://graph.microsoft.com/.default"
host="Host: login.microsoftonline.com"

access_token_url="https://login.microsoftonline.com/${tenant_id}/oauth2/v2.0/token"

token_response=$(curl -s -X POST -H  "Conent-Type: application/json" --data-urlencode $scope --data-urlencode $grant_type --data-urlencode $client_id --data-urlencode $client_secret $access_token_url)
access_token=$(python parse_json.py "${token_response}" access_token)

if [ $? -eq 1 ]
then
    echo $access_token
    exit
fi

site_response=$(curl -s -X GET -H "Authorization: Bearer $access_token" https://graph.microsoft.com/v1.0/sites/$staging_site_url:/sites/$site_name\?\$select=id)
site_id=$(python parse_json.py "$site_response" site_id)

if [ $? -eq 1 ]
then
    echo $site_id
    exit
fi

drive_response=$(curl -s -X GET -H "Authorization: Bearer $access_token" https://graph.microsoft.com/v1.0/sites/$site_id/drive\?\$select=id)
drive_id=$(python parse_json.py "$drive_response" drive_id)

if [ $? -eq 1 ]
then
    echo $drive_id
    exit
fi

files_response=$(curl -s -X GET -H "Authorization: Bearer $access_token" https://graph.microsoft.com/v1.0/drives/$drive_id/root:/$files_location:/children\?select=name,@microsoft.graph.downloadUrl,size)
if [ $? -eq 1 ]
then
    echo $files_response
    exit
fi

files=$(python files.py "$files_response" $file_pattern $staging_dir)

$(cd $staging_dir && find . -type f -size +10k -exec split -b 10K {} {}_ \; -exec rm {} \; && cd $OLDPWD)