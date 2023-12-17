#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

#mkdir /tmp/robo-shop.logs/

#LOG=/tmp/robo-shop.logs/$(date +%F-%M-%H ).$0;
#script &>"$LOG";

VALIDATION(){
    if [ $1 -eq 0 ];
    then 
        echo -e "$2 $CG SUCCESS $CN"
    else
        echo -e "$2 $CR FAILED $CN Please check Log files '/tmp/robo-shop-logs/'"
        exit;
    fi
};

if [ $(id -u) -ne 0 ]
then 
    echo -e "Please run this Script as $CR ROOT USER $CN"
    exit;
else
    echo -e "You are $CG Root User $CN"
fi

dnf module disable nodejs -y;
VALIDATION $? "Disabling Nodejs" 
dnf module enable nodejs:18 -y;
VALIDATION $? "Enabling Nodejs-18"
echo "Installing Nodejs"
dnf install nodejs -y;
VALIDATION $? "Intalling Nodejs-18"
echo "Creating User"
id roboshop

ES=$?
if [ $ES = 0 ];
then
    echo -e "User Already $CR Exists $CN"
    echo "Do you want to Proceed-Y (or) Exit the script-N ? Type Y/N"
    read -r RESPONSE;
    if [ "$RESPONSE" == "n" ]|| [ "$RESPONSE" == "N" ] ;
    then 
        echo -e "$CY EXITING SCRIPT $CN"
        exit 1;
    elif [ "$RESPONSE" == "y" ] || [ "$RESPONSE" == "Y" ];
    then
        true;
    else 
        echo "Invalid Response"
        exit 1;
    fi
else 
    useradd roboshop;
fi

VALIDATION $? "Creating User"
echo "Making App Directory"
mkdir /app
VALIDATION $? "Making App Directory"
cd /app
echo "Downloading Catalogue.Service"
wget https://roboshop-builds.s3.amazonaws.com/catalogue.zip
unzip catalogue.zip
VALIDATION $? "Unziping Catalogue"
echo "Installing Catalaogue.Service"
npm install
cd /
VALIDATION $? "Installing Catalaogue.Service"
cp /home/centos/robo-shop/catalogue.service /etc/systemd/system/
VALIDATION $? "Loading Catalaogue.Service"
echo -e "$CY Starting Catalogue $CN"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo "Installing Mongodb client"
cp /home/centos/robo-shop/mongo.repo /etc/yum.repos.d/
dnf install mongodb-org-shell -y
VALIDATION $? "Installing Mongodb client"
echo "Loading Schema into Mongodb"
mongo --host mongodb.ladoo.shop </app/schema/catalogue.js
VALIDATION $? "Loading Schema into Mongodb"
netstat -lntp