#!/bin/bash

source vars

find $input_dir -type f -iname $file_pattern -print0 | while IFS= read -r -d $'\0' file; do
    cp $file $staging_dir/
    if [ $? -eq 0 ]
    then
        echo "File copied successfully: $file"
    else
        echo "Error copying file: $file" 
    fi
done

$(cd $staging_dir && find . -type f -size +3M -exec split -b 3M {} {}_ \; -exec rm {} \; && cd $OLDPWD)