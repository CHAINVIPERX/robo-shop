#!/bin/bash

#p1=Juliet
#p2=Romeo

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

#VALIDATION() {
#    if [ $1 -eq 0 ]; then
#        echo " $2 Installation Successful"
#    else
#        echo " $2 Installation Failed"
#        exit 1
#    fi
#}

#TIME=$(date +%F-%H-%M-%S)
#LOG="/tmp/$0-$TIME.log"
#ID=$(id -u)
#if [ $ID -eq 0 ]; then
#    echo "ROOT User"
#else
#    echo " Not a ROOT User"
#    exit 1 &>>$LOG
#fi

#yum install mysql -y &>>$LOG

#VALIDATION $? mysql

#yum install git -y &>>$LOG

#VALIDATION $? Git

#echo -e "MY name is \e[33m BALAJI"

#for i in {1..1054}; do
#    echo "$i"
#done

#echo " enter d to see date"
#cho " enter pd to see present working directory"
#read -r RESPONSE 
#caseresponse="${RESPONSE,,}"
#case $caseresponse in
#d) date;;
#pd) pwd;;
#*) echo "Invalid input";;
#esac

#read -rp "Enter 2 numbers" A B
#read -rp "Enter a for addition , s for substraction" RESPONSE
#addition()
#{
#    answer=$(($1+$2));
#    echo " $1 + $2 is = ${answer}"
#substraction()
#{
#   #let answer=$1-$2
#   echo " $1-$2 is $(($1-$2))"
#}
#caseresponse="${RESPONSE,,}"
#case $caseresponse in
#a) addition "$A" "$B" ;;
#s) substraction "$A" "$B" ;;
#) echo "Invalid input" ;;
#esac




#read -rp "Enter log path to delete them :" LOCATION
#LOGSOURCE=$(dirname "${LOCATION}")
#if [ ! -d "$LOGSOURCE" ]; 
#then
#    echo " ${LOGSOURCE} Directory doesnt exist"
#    exit 1;
#fi
#cd "${LOGSOURCE}"
#LOGSTODELETE=$(find . -type f -mtime +14 -name "*.log") 
#while IFS=$'\n' read -r filename
#do
#    echo "Deleting ${filename}";
#    rm -f "${filename}";
#done <<< "${LOGSTODELETE}"


name=""
wishes=""
echo "${name} is a human"
echo "${wishes} is a wish"
usage(){
    echo "Usage :: $(basename $0) -n <name> -w <wishes>"
    echo "Options ::"
    echo "-n, specify the name"
    echo "-w, specify the wishes"
    echo "-h, For help"
}
while getopts ":h:n:w" opt;
do
    case $opt in
        n) name="${OPTARG}";;
        w) wishes="${OPTARG}";;
        h|*) usage;exit;;
    esac
done