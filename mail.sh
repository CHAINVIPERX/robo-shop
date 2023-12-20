#!/bin/bash

SUBJECT=$1
TO_TEAM=$2
BODY=$3
TO_ADDRESS=$4
E_BODY=$(printf '%s\n' "$BODY" | sed -e 's/[]\/$*.^[]/\\&/g');
EMAIL=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/BODY/$E_BODY/g"  mail.html)
echo "$EMAIL" | mail -s "$(echo -e "$SUBJECT\nContent-Type: text/html")" "$TO_ADDRESS"