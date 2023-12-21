#!/bin/bash

AMI_ID="ami-03265a0778a880afb"
SEC_ID="sg-070811a8d8f58361b"
T_2=("WEB" "USER" "CATALOGUE" "CART" "PAYMENTS" "REDIS")
T_3=("MONGODB" "RABBITMQ" "SHIPPING" "MYSQL")
HOSTEDZONE_ID="Z04496693IX1XH6O3HSH2"
DOMAIN_NAME="ladoo.shop"

for ((i=0;i < ${#T_2[*]};i++))
do
    echo "Creating ${T_2[$i]} Instance"
    PrivateIpAddress=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --security-group-ids ${SEC_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${T_2[$i]}}]" --query "Instances[0].PrivateIpAddress" --output text)
    echo " PRIVATE IP ADDRESS:::${T_2[$i]}:${PrivateIpAddress}"

    aws route53 change-resource-record-sets \
        --hosted-zone-id $HOSTEDZONE_ID \
        --change-batch "{
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                 "Name": "'${T_3[$i],,}'.'${DOMAIN_NAME}'",
                        "Type": "A",
                        "TTL": 300,
                        "ResourceRecords": [
                            {
                                "Value": "'$PrivateIpAddress'"
                            }
                        ]
                    }
                }
            ]
        }"
done

for ((i=0;i < ${#T_3[*]};i++))
do
    echo "Creating ${T_3[$i]} Instance"
    PrivateIpAddress=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.small --security-group-ids ${SEC_ID}  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${T_3[$i]}}]" --query "'Instances[0].PrivateIpAddress" --output text)
    echo "PRIVATE IP ADDRESS:::${T_3[$i]}:${PrivateIpAddress}"
done