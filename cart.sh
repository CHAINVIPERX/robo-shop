#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

VALIDATION (){
    if [ $1 = 0 ];
    then
        echo -e "$2 is ${CG}SUCCESSFUL${CN}"
    else
        echo -e "$2 is ${CR}FAILED${CN}"
        exit 1;
    fi
}

if [ $(id -u) -ne 0 ];
    then 
        echo -e "Please run this script as ${CG}ROOT USER${CN}"
              exit 1;
    else
        true;
fi

echo -e "Installing ${CY}NODEJS${CN}"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
VALIDATION $? "Installing NODEJS"

id roboshop -u
ES=$?
if [ $ES = 0 ];
    then
        echo "User already exists"
        echo -e "Do you want to ${CY}PROCEED-Y${CN} (or) Do you want to ${CY}EXIT-N${CN}?"
        read -r RESPONSE

        if [ "$RESPONSE" = "Y" ] || [ "$RESPONSE" = "y" ];
            then
                true;
            elif [ "$RESPONSE" = "N" ] || [ "$RESPONSE" = "n" ];
                then
                    echo -e "${CY}Exiting Script${CN}"
                    exit 1;
            else
                echo -e "${CR}Invalid response${CN}";
                exit 1;
        fi
    else 
        useradd roboshop 
fi
VALIDATION $? "Creating User"
echo -e "${CY}Making Directory${CN}"
mkdir /app
cd /app
VALIDATION $? "Making Directory"

echo -e "${CY}Downloading Cart.Service${CN}"
wget https://roboshop-builds.s3.amazonaws.com/cart.zip
unzip -o cart.zip
echo -e "${CY}Installing Cart.Service${CN}"
npm install
VALIDATION $? "Installing Cart"

echo -e "${CY}Configuring Cart.Service${CN}"
cp /home/centos/robo-shop/cart.service /etc/systemd/system/cart.service
VALIDATION $? "Configuring Cart.Service"

echo -e "${CY}Starting Cart.Service${CN}"
systemctl daemon-reload
systemctl enable cart
systemctl start cart
VALIDATION $? "Starting Cart"
netstat -lntp
