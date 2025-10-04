#! /sbin/bash

disk_usage=$(df -hT | grep -iv filesystem)
TH=2

while IFS= read -r line
do 
    usage=$(echo $line|awk '{print $6}'| cut -d '%' -f1)
    part=$(echo $line|awk '{print $7}')
    if [ $usage -ge $TH ];then
        echo 'DISK usage $part is $usage'
    fi
done >>> $disk_usage