#!/bin/bash

#p1=alekhya
#p2=balaji

#echo "$p1:I Love You"
#echo "$p2:Okay.Love you too"
#echo "$p1:Its a Prank

#DATE=$(date)
#echo "Date and time is ${DATE}"

#echo "Please enter your Age"
#read AGE
#echo "Age is $AGE"

#n1=$1
#2=$2

#SUM=$(($n1+$n2))
#echo "sum of $n1 and $n2 is $SUM"

#FRUITS=("JACKFRUIT" "ORANGE" "CAPPLE")
#echo "${FRUITS[0]}"
#echo "${FRUITS[1]}"
#echo "${FRUITS[2]}"
#echo "${FRUITS[@]}"

#number=$1
#if [ $number -gt 50 ]
#then
#    echo " The number $number is greater than 50"
#else
#   echo "The number $number is smaller than 50"
#fi

#VALIDATION() {
#        echo " $2 Installation Successful"
#    else
#        echo " $2 Installation Failed"
#        exit 1
#    fi
#}

#ID=$(id -u)
#if [ $ID -eq 0 ]; then
#   echo "ROOT User"
#else
#   echo " Not a ROOT User"
#    exit 1
#fi

#yum install mysql -y

#VALIDATION $? mysql

#yum install git -y

#VALIDATION $? Git

VALIDATION() {
    if [ $1 -eq 0 ]; then
        echo " $2 Installation Successful"
    else
        echo " $2 Installation Failed"
        exit 1
    fi
}

TIME=$(date +%F-%H-%M-%S)
LOG="/tmp/$0-$TIME.log"
ID=$(id -u)
if [ $ID -eq 0 ]; then
    echo "ROOT User"
else
    echo " Not a ROOT User"
    exit 1 &>>$LOG
fi

yum install mysql -y &>>$LOG

VALIDATION $? mysql

yum install gisft -y &>>$LOG

VALIDATION $? Git
