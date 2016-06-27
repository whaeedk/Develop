#!/bin/bash

CURL="/usr/bin/curl"
AWK="/usr/bin/awk"
echo -n "Please enter the website url you want to measure for response time: "
read url
URL="$url"
result=`$CURL -o /dev/null -s -w %{time_connect}:%{time_starttransfer}:%{time_total} $URL`
echo " Time_Connect Time_StartTransfer Time_Total "
echo $result | $AWK -F: '{ print $1" "$2" "$3 }'
