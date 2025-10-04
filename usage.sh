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
        MESSAGE+="High usage on $part is $usage % <br>" 
    fi
done <<< $disk_usage

echo -e "$MESSAGE1"

MESSAGE=$(echo "$MESSAGE1" | tr -d '\r')

sh mail.sh "rajivklce@gmail.com" "High disk usage" "High  DISK USAGE" "$MESSAGE" "$IP" "$TO_TEAM"
