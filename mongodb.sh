#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

VALIDATION(){
    if [ $1 -eq 0 ]; 
    then echo " Installation of $2 is SUCCESS " 
        
    else echo " Installation of $2 has FAILED"
    fi
}

ID=$(id -u)
if [ $ID -ne 0 ]; 
then
    echo -e "Please Run this Script as $CY ROOT USER $CN"
    exit 1
else
    echo -e "$CG ROOT USER $CN"
fi

echo -e "Installing $CG Mongodb $CN"

dnf install mongodb -y



if [ $? -eq 1 ]; 
then
    echo -e "Creating $CY Mongodb $CN Repo"
    cp mongo.repo /etc/yum.repos.d/
    echo -e"installing $CY mongodb $CN"
    dnf install mongodb-org -y
    VALIDATION $? Mongodb
    
fi

echo -e" Configuring $CY Mongodb $CN"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

echo "Enabling Mongod"
systemctl enable mongod
echo "Starting Mongod"
systemctl start Mongod

netstat -lntp
