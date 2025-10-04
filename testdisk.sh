#! /sbin/bash

disk_usage=$(df -hT | grep -iv filesystem)
clean_output=$(echo "$disk_usage" | tr -d '\r')

echo "$clean_output"
