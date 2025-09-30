#! /sbin/bash

# count=5

# while [ $count -gt 0]
# do 
#    count=$(($count -1))
#    echo "count is $count"
# done


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODBHOST="mongodb.daws86s.fun"
SCRIPT_L=$PWD
LOG_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0| cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
FILESTODEL= $(find $SOURCE_DIR -name *.log -mtime +14)

SOURCE_DIR=/home/ec2-user/shell-roboshop/app-logs
if [ ! -d $SOURCE_DIR ]; then
    echo "ERROR in directory"
    exit 1 
fi

while IFS= read -r filepath
do
    echo " deleting the files ::::$filepath"
done <<< $SOURCE_DIR