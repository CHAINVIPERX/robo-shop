#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"



VALIDATION(){
    if [ $1 -eq 0 ]; 
    then echo -e "$2 is $CG SUCCESSFUL $CN "
        
    else echo -e "$2 has $CR FAILED $CN"
         exit 1;
    fi; 
}

ID=$(id -u)
if [ $ID -ne 0 ]; 
then
    echo -e "Please Run this Script as $CR ROOT USER $CN"
    exit 1
else
    echo -e "$CG ROOT USER $CN"
fi

echo -e "${CY}Creating Mongodb Repo $CN"
cp /home/centos/robo-shop/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATION $? "Creating Mongodb Repo"

echo -e "${CY}Installing Mongodb $CN"
dnf install mongodb-org -y
VALIDATION $? "Installing Mongodb"

echo -e "$CY Configuring Mongodb $CN"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATION $2 "Configuring Mongodb"

echo -e "${CY}Enabling Mongodb $CN"
systemctl enable mongod
VALIDATION $2 "Enabling Mongodb"

echo -e "${CY}Starting Mongodb ${CN}"
systemctl start mongod
VALIDATION $? "Starting Mongodb"
netstat -lntp

