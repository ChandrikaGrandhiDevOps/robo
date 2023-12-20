#!/bin/bash
 SOURCE_DIR="/tmp/shell-script"

 R="\e[31m"
 G="\e[32m"
 Y="\e[33m"
 N="\e[0m"

 if [ ! -d $SOURCE_DIR ]
   then 
      echo -e "$R source directory dosn't exist"
fi 

FILES_TO_DELETE=$(find . -type f -mtime +7 -name "*.log")

while IFS= read -r line
do
   echo "Deleting file: $line"

done <<< $FILES_TO_DELETE



