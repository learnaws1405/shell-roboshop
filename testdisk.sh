#! /sbin/bash

disk_usage=$(df -hT | grep -iv filesystem)


TH=2
IP=$(curl -s  http://169.254.169.254/latest/meta-data/local-ipv4)
MESSAGE1="''"
TO_TEAM="DEVOPS TEAM"
while IFS= read -r line
do 
    usage=$(echo $line|awk '{print $6}'| cut -d '%' -f1)
    part=$(echo $line|awk '{print $7}')
    if [ $usage -ge $TH ];then
        MESSAGE+="High usage on $part is $usage % \n" 
    fi
done <<< $clean_output

echo -e "$MESSAGE1"

clean_output=$(echo "$MESSAGE1" | tr -d '\r')

echo "$clean_output"