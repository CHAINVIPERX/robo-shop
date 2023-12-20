#!/bin/bash

DISKS=$(df -hT | grep xfs );
ALERTUSAGE=1

while IFS= read -r line
do 
    DISKNAME=$( echo $line | awk '{print $1}')
    DISKUSAGE=$(echo $line | awk '{print $6}' | cut -d '%' -f 1)
       if [ "${DISKUSAGE}" -gt "${ALERTUSAGE}" ]
        then 
        ALERT="${DISKNAME} disk usage has crossed the <br> alert threshold of ${ALERTUSAGE}% Current Usage is at ${DISKUSAGE}%"
            sh mail.sh  "ALERT!HIGH DISK USAGE" "DEVOPS TEAM" "$ALERT" "kbalajireddy112@gmail.com"
        else 
            true;
        fi

done <<<"${DISKS}"