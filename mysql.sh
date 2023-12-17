#!/bin/bash
CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

VALIDATION(){
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
    echo -e "You must be ${CR}ROOT USER${CN} to run this script"
    exit 1;
else 
    true ;
fi

echo -e "Configuring ${CY}MYSQL Repository${CN}"
cp /home/centos/robo-shop/mysql.repo /etc/systemd/system/mysql.repo
VALIDATION $? "Creating MYSQL Repository"

echo -e "Installing ${CY}MYSQL${CN}"
dnf module disable mysql -y
dnf install mysql-community-server -y
VALIDATION $? "Installing MYSQL"

echo -e "Starting ${CY}MYSQL${CN}"
systemctl enable mysql
systemctl start mysql
VALIDATION $? "Starting MYSQL"

echo -e "Configuring User"
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATION $? "Configuring User"
