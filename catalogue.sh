#!/bin/bash

CR="\e31m"
CG="\e32m"
CY="\e33m"
CN="\e0m"

LOG=/tmp/robo-shop-logs/$(date +%F-%M-%H ).$0;
exec &>LOG;

VALIDATION(){
if [ $1 -eq 0 ];
then 
    echo -e "$2 $CG SUCCESS $CN"
else
    echo -e "$2 $CR FAILED $CN Please check Log files '/tmp/robo-shop-logs/'"
    exit;
fi
};

if [ $(id) -ne 0 ];
then 
    echo -e "Please run this Script as $CR ROOT USER $CN"
    exit;
else
    echo -e "You are Root User"
fi

dnf module disable nodejs -y;
VALIDATION $? Disabling Nodejs 
dnf module enable nodejs:18 -y;
VALIDATION $? Enabling Nodejs-18
echo "Installing Nodejs"
dnf install nodejs -y;
VALIDATION $? Intalling Nodejs-18
echo "Creating User"
useradd roboshop
VALIDATION $? Creating User
echo "Making App Directory"
mkdir /app
VALIDATION $? Making App Directory
cd /app
echo "Downloading Catalogue.Service"
wget https://roboshop-builds.s3.amazonaws.com/catalogue.zip
unzip catalogue.zip
VALIDATION $? Unziping Catalogue
echo "Installing Catalaogue.Service"
npm install
cd /
VALIDATION $? Installing Catalaogue.Service
cp /home/centos/robo-shop/catalogue.service /etc/systemd/system/
VALIDATION $? Loading Catalaogue.Service
echo -e "$CY Starting Catalogue $CN"
systemctl daemom-reload
systemctl enable catalogue
systemctl start catalogue

echo "Installing Mongodb client"
cp /home/centos/robo-shop/mongo.repo /etc/yum.repos.d/
dnf install mongodb-org-shell -y
VALIDATION $? Installing Mongodb client
echo "Loading Schema into Mongodb"
mongo --host cat.ladoo.shop </app/schema/catalogue.js
VALIDATION $? Loading Schema into Mongodb
netstat -lntp