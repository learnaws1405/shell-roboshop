#!/sbin/bash

TO_ADDRESS=$1
SUBJECT=$2
ALERT_TYPE=$3
MESSAGE=$4
IP=$5
TO_TEAM=$6

escape_sed() {
  echo "$1" | sed -e 's/[&/\]/\\&/g'
}

FORMATTED_BODY=$(escape_sed "$MESSAGE")
#FORMATTED_BODY=$(printf '%s\n' "$MESSAGE" | sed -e 's/[]\/$*.^[]/\\&/g')


FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/IP_ADDRESS/$IP/g" -e "s/MESSAGE/$FORMATTED_BODY/g" body.template)
#FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/IP_ADDRESS/$IP/g" -e "s/MESSAGE/$MESSAGE/g" body.template)

{
echo "To: $TO_ADDRESS"
echo "Subject: $SUBJECT"
echo "Content-Type: text/html"
echo ""
echo "$FINAL_BODY"
} | msmtp "$TO_ADDRESS"
