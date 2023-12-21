#!/bin/bash

AMI_ID="ami-03265a0778a880afb"
SEC_ID="sg-070811a8d8f58361b"
EC_2=("WEB" "USER" "CATALOGUE" "CART" "PAYMENTS" "REDIS")
EC_3=("MONGODB" "RABBITMQ" "SHIPPING" "MYSQL")

T_2_MICRO=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --security-group-ids ${SEC_ID})

T_3_SMALL=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.small --security-group-ids ${SEC_ID})

for ((i=0;i <= ${#EC_2[*]};i++))
do
    echo "Creating ${EC-2[$i]} Instance"
    $T_2_MICRO
    echo "DONE"
done

for ((i=0;i <= ${#EC_3[*]};i++))
do
    echo "Creating ${EC_3[$i]} Instance"
    $T_3_SMALL
    echo "DONE"
done