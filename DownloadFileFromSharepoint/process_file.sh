#!/bin/bash

folder="/tmp/"
file_name="${folder}${2}"
curl -s $1 --output $file_name

unzip -qq -o $file_name -d $3
rm $file_name