#!/bin/bash
user='admin'
pwd='admin'
#your router IP address
ip='http://192.168.11.1/'

#Here is the url that points to the statistics page, you can sort the changing the value of sortType:
#1 ip address, 2 total packets, 3 total bytes, 4 total packets, 5 total bytes

url='userRpm/SystemStatisticRpm.htm?interval=5&Refresh=Refresh&sortType=5&Num_per_page=100'
link="$ip$url"


curl -s -u $user:$pwd "$link" --referer """$link"""\
| awk '/Array/ {flag=1;next} /SCRIPT/{flag=0} flag {print}'\
| awk 'NF==13{print}{}'\
| sed 's/[",]//g' |  cut -d " " -f2,7

#the columns of the output table corresponds to:
# client|ip address|mac|t.packets|t.bytes|c.packets|c.bytes|ICMP Tx|ICMP Tx|UDP Tx|UDP Tx|SYN Tx|SYN Tx
# you can customize the output table by editing the "cut" command, in this example IP address[1] and current bytes[7] are shown.
