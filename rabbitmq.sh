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
    echo -e "This script must be run as ${CR}ROOT USER${CN}"
    exit 1;
else
    true;
fi

echo -e "${CY}Preparing Prerequisites${CN}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
VALIDATION $? "Preparing Prerequisites"

echo -e "${CY}Installing RabbitMQ${CN}"
dnf install -y rabbitmq-server
VALIDATION $? "Installing RabbitMQ"

echo -e "${CY} Starting RabbitMQ${CN}"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
VALIDATION $? "Starting RabbitMQ"

echo -e "${CY}Configuring RabbitMQ${CN}"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATION $? "Configuring RabbitMQ"