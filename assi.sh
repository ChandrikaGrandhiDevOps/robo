#!/bin/bash

SOURCE_DIR="\tmp\assi"

if [ ! -d $SOURCE_DIR ]
 then
    echo -e "$R there is no directory in this path"
fi  

FILES_TO_DELETE=$(type $SOURCE_DIR -type f -mtime +5 -name "*.pdf")

while IFS = read -r line
do
 echo "Deleting the file: $line"
 rm -rf $line
done
