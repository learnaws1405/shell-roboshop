#!/sbin/bash

TO_ADDRESS=$1
SUBJECT=$2
ALERT_TYPE=$3
MESSAGE=$4
IP=$5

FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/IP_ADDRESS/$IP/g" -e "s/MESSAGE/$MESSAGE/g")

{
echo "To: $TO_ADDRESS"
echo "Subject: $SUBJECT"
echo "Content-Type: text/html"
echo ""
echo "$EMAIL_BODY"
} | msmtp "$TO_ADDRESS"

