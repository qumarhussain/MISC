#!/bin/bash

# Load the property file using 'source'
source properties.file

# Loop through each key in the array
for directory in "${!directories[@]}"; do
    # Get the path to the directory
    path="${directories[$directory]}"
    # Check if the directory exists
    if [ -d "$path" ]; then
        # Print the directory name
        echo "Checking files in directory $path"
        # Check for files in the directory
        for file in "$path"/*; do
            # Check if the file is a regular file
            if [ -f "$file" ]; then
                # Print the file name
                echo "Found file $file"
            fi
        done
    else
        # Print an error message if the directory does not exist
        echo "Error: directory $path does not exist"
    fi
done
