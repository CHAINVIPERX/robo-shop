#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

VALIDATION(){
    if [ $1 -eq 0 ]; 
    then echo -e " Installation of $2 is $CG SUCCESS $CN "
         return 0;
    else echo -e " Installation of $2 has $CR FAILED $CN"
         return 1;
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

VALIDATION $? Mongodb

if [ $? -ne 0 ]; 
then
    echo  "Creating  Mongodb  Repo"
    cp mongo.repo /etc/yum.repos.d/
    echo  "Installing  Mongodb "
    dnf install mongodb-org -y
    VALIDATION $? Mongodb
    return 0
fi

if [ $? -eq 0 ];
then 
    echo -e "Installation $CR FAILED $CN"
exit 1
fi

echo " Configuring  Mongodb "
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

echo "Enabling Mongod"
systemctl enable mongod
echo "Starting Mongod"
systemctl start mongod

netstat -lntp
