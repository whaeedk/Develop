#!/bin/bash
SNMP_PASSWORD="whatever your password for snmp"
snmpPoll() {
icmp=$(ping -c 1 $1)
if [[ $? -eq 0 ]]; then
echo "$1 is pinging..."
nsout=$(nslookup $1 | awk -F 'name = ' ' { printf $2 } ')
echo "IP resolves to $nsout"
output=$(snmpwalk -v 2c -c $SNMP_PASSWORD $1 .1.3.6.1.2.1.1.5)
if [[ $? -eq 0 ]]; then
echo $output
hostname=$(nslookup $(echo $output | awk -F ': ' ' { print $2 } '))
echo $hostname
else
echo $output
echo "not performing nslookup"
fi
else
echo "$1 not responding to ping"
fi
}



prompt() {
read -p "$1"" : " val
snmpPoll $val
}

while true; do prompt "IP Address"; done
