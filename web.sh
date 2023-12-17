#!/bin/bash
CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

VALIDATION(){
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
    echo -e "You must be ${CR}ROOT USER${CN} to run this script"
    exit 1;
else 
    true;
fi

echo -e "${CY}Installing NGINX${CN}"
dnf install nginx -y
VALIDATION $? "Installing NGINX"

echo -e "${CY}Downloading Web Interface${CN}"
rm -rf /usr/share/nginx/html/
cd /usr/share/nginx/html
wget https://roboshop-builds.s3.amazonaws.com/web.zip
unzip -o web.zip
rm -rf /usr/share/nginx/html/web.zip
VALIDATION $? "Downloading Web Interface"

echo -e "${CY}Configuring NGINX${CN}"
cp /home/centos/robo-shop/roboshop.conf /etc/nginx/default.d/roboshop.conf
VALIDATION $? "Configuring NGINX"

echo -e "${CY}Starting NGINX${CN}"
systemctl enable nginx
systemctl start nginx
VALIDATION $? "Starting NGINX"
netstat -lntp
