#!/bin/bash

SUBJECT=$1
TO_TEAM=$2
BODY=$3
TO_ADDRESS=$4

EMAIL=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/BODY/$BODY/g"  mail.html)
echo "$EMAIL" | mail -s "$(echo -e "$SUBJECT\nContent-Type: text/html")" "$TO_ADDRESS"