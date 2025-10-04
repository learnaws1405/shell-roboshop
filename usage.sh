#! /sbin/bash

disk_usage=$(df -hT | grep -iv filesystem)
TH=2
IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
MESSAGE="''"
while IFS= read -r line
do 
    usage=$(echo $line|awk '{print $6}'| cut -d '%' -f1)
    part=$(echo $line|awk '{print $7}')
    if [ $usage -ge $TH ];then
        MESSAGE+="High usage on $part is $usage % \n" 
    fi
done <<< $disk_usage

echo -e "$MESSAGE"