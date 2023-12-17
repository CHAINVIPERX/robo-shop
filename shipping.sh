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
        echo -e "$2 is ${CR}FAILED${CN}"
        exit 1;
    fi
}

if [  $(id -u) -ne 0 ];
then
    echo -e "This script must be run as ${CR}ROOT USER${CN}"
    exit 1;
else
    true;
fi
echo -e "${CY}Preparing Prerequisites${CN}"
dnf install maven -y
VALIDATION $? "Preparation"

echo -e "${CY}Creating User${CN}"
id roboshop -u
ES=$?
if [ ${ES} = 0 ];
then
    echo "User Already Exists"
    echo -e "Do You Want To ${CY}PROCEED-Y${CN} (or) Do You Want To ${CY}EXIT-N${CN}?"
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
VALIDATION $? "Creating User"

echo -e "Downloading and Installing ${CY}Shipping Package${CN}"
mkdir /app
cd /app
wget https://roboshop-builds.s3.amazonaws.com/shipping.zip
unzip -o /app/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar
VALIDATION $? "Downloading and Installing Shipping Package"

echo -e "Loading ${CY}Shipping service${CN}"
cp /home/centos/robo-shop/shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
VALIDATION $? "Starting Shipping service"

echo -e "Installing ${CY}MYSQL Client${CN}"
dnf install mysql -y
mysql -h mysql.ladoo.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql 
VALIDATION $? "Installing and Loading ${CY}MYSQL Client${CN}"

systemctl restart shipping
netstat -lntp