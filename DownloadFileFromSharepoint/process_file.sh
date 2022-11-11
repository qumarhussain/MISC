#!/bin/bash

folder="/tmp/"
file_name="${folder}${2}"
curl -s $1 --output $file_name
echo "Going to unzip file: ${2}"
unzip -qq -o $file_name -d $3
rm $file_name
echo "Removed zip file: $file_name"