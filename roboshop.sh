#! /sbin/bash

AMIID="ami-09c813fb71547fc4f"
SGID="sg-0237e990ac2b2cf30"
HOSTED_ZID="Z0131025394K0S300RRJQ"
DOMAIN_NAME="dlearnaws.fun"

for instance in $@
do
Instance_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0237e990ac2b2cf30 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

  if [ $instance != "frontend" ]; then 
    IP=$(ws ec2 describe-instances --instance-ids $Instance_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
    RECORD_NAME="$instance.$DOMAIN_NAME"
  else
    IP=$(aws ec2 describe-instances --instance-ids $Instance_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    RECORD_NAME="$DOMAIN_NAME"
  fi
echo "$instance = $IP"
aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ZID \
  --change-batch '
  {
    "Comment": "Updating record set"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$RECORD_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP'"
        }]
      }
    }]
  }
done