#!/bin/bash

AMI_ID="ami-03265a0778a880afb"
SEC_ID="sg-070811a8d8f58361b"
EC_2=("WEB" "USER" "CATALOGUE" "CART" "PAYMENTS" "REDIS")
EC_3=("MONGODB" "RABBITMQ" "SHIPPING" "MYSQL")

for ((i=0;i <= ${#EC_2[*]};i++))
do
    echo "Creating ${EC_2[$i]} Instance"
    aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --security-group-ids ${SEC_ID}
    echo "DONE"
done

for ((i=0;i <= ${#EC_3[*]};i++))
do
    echo "Creating ${EC_3[$i]} Instance"
    aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.small --security-group-ids ${SEC_ID}
    echo "DONE"
done