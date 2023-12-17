#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

VALIDATION (){
    if [ $1 -eq 0 ];
    then
        echo -e "$2 is ${CG}SUCCESSFUL${CN}"
    else
        echo -e "$2 has ${CR}FAILED${CN}"
        exit 1;
    fi
}
if [ $(id -u) -ne 0 ];
then
    echo -e "This script must be run as ${CR}ROOT USER${CN}"
    exit 1;
else
    true;
fi

echo -e "${CY}Installing${CN} PYTHON"
dnf install python36 gcc python3-devel -y
VALIDATION $? "Installing PYTHON"

id roboshop 
ES=$?
if [ ${ES} = 0 ];
then 
    echo -e "User Already ${CR}Exists${CN}"
    echo -e "Do You Want To ${CY}PROCEED-Y${CN} (or) Do You Want To ${CY}Exit-N${CN}?"
    read -r RESPONSE
    if [ "${RESPONSE}" == "Y" ] || [ "${RESPONSE}" == "y" ];
    then
        true;
    elif [ "${RESPONSE}" == "N" ] || [ "${RESPONSE}" == "n" ];
    then
        exit 1;
    else 
        echo -e "${CR}Invalid Input${CN}"
        exit 1;
    fi
else 
    useradd roboshop;
fi

echo -e "${CY}Installing${CN} Payment Service"
mkdir /app
cd /app
wget https://roboshop-builds.s3.amazonaws.com/payment.zip
unzip -o /app/payment.zip
pip3.6 install -r requirements.txt
VALIDATION $? "Installing Payment Service"

echo -e "${CY}Configuring${CN} Payment Service"
cp /home/centos/robo-shop/payment.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment
systemctl start payment
VALIDATION $? "Configuring Payment Service"
netstat -lntp