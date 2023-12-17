#!/bin/bash

CR="\e[31m"
CG="\e[32"
CY="\e[33m"
CN="\e[0m"
GB="\e[1;${CG}m"
RI="\e[3;${CR}m"

VALIDATIOM (){
    if [ $1 -eq 0 ];
    then 
        echo -e "$2 is ${BG} SUCCESSFUL ${CN}"
    else
        echo -e "$2 has ${RI} FAILED ${CN}"
    fi
}

if [ $(id -u) != 0 ];
then
    echo -e "This script must be run as ${CY}ROOT USER ${CN}"
    exit 1
else
    true;
fi

echo "Installing Nodejs"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
VALIDATION $? "INSTALLING NODEJS"

echo "Creating User"
id roboshop
ES=$?
RESPONSE
if [ $ES = 0 ];
then
    echo -e "User Already ${CY}Exists${CN}";
    echo -e "Do You want to ${CY}PROCEED-Y${CN} (or) Do You Want To ${CY}EXIT-N${CN}"
    read -r RESPONSE
    if [ "$RESPONSE" == "Y" ] || [ "$RESPONSE" == "y" ];
    then 
        true;
    elif [ "$RESPONSE" == "N" ] || [ "$RESPONSE" == "n" ];
    then
        echo -e "${GB}EXITING SCRIPT${CN}"
        exit 1;
    else
        echo -e "${RI}INVALID RESPONSE ${CN}"
        exit 1;
    fi
else 
    useradd roboshop;
fi
VALIDATION $? "CREATING USER"

mkdir /app
VALIDATION $? "CREATING DIRECTORY"
cd /app

echo "Downloading user.service"
wget https://roboshop-builds.s3.amazonaws.com/user.zip
unzip /app/user.zip
npm install
VALIDATION $? "Installing User.service"

cp /home/centos/robo-shop/user.service /etc/systemd/system/user.service
echo "Starting user.service"
systemctl daemon-reload
systemctl enable user
systemctl start user
VALIDATION $? "Starting User"
netstat -lntp

