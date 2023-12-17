#!/bin/bash

CR="\e[31m"
CG="\e[32m"
CY="\e[33m"
CN="\e[0m"

mkdir /tmp/robo-shop.logs/

ES=$?;
if [ $ES != 0 ];
then
    echo " Directory Already Exists...$CY SKIP $CN"
else
    true;
fi

LOG=/tmp/robo-shop.logs/$(date +%F-%H-%M).$0;
script &>"$LOG"

VALIDATION(){
    if [ $1 -eq 0 ];
    then
        echo -e "Installation of $2 is $CG Successful $CN"
    else
        echo -e "Installation of $2 has $CR Failed $CN"
    fi
}
if [ $(id -u) -ne 0 ];
then
    echo -e "Please run as $CR ROOT USER $CN"
    exit 1
else 
    echo -e "You are $CG ROOT USER $CN"
fi

echo "Installating REMI Repository"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATION $? "REMI REPOSITORY"

echo "Enabling Redis-6.2"
dnf module enable redis:remi-6.2 -y
VALIDATION $? "REDIS-6.2"

echo "Installing Redis"
dnf install redis -y
VALIDATION $? "REDIS"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
systemctl enable redis
systemctl start redis
netstat -lntp