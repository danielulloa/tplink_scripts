#!/bin/bash
printf "Hello $USER, you can use this tool to discover information about your TP-Link router\n"
ip='http://192.168.1.1'
user='admin'
pwd='admin'

while [ 1 ];
do
	printf 'Option:'
	read DISTR

case $DISTR in

	pppoe)
		echo "Here are the PPPoE credentials"
		curl -s -u $user:$pwd "$ip/userRpm/PPPoECfgRpm.htm?wan=0" --referer "$ip"/ | sed -n "/^var pppoeInf = new Array($/,/^<\/SCRIPT>$/p" | head -n -32 | tail -n +9| sed 's/[",]//g'
	;;
		
	ddns)
		echo "Here are the DDNS credentials"
		curl -s -u $user:$pwd "$ip/userRpm/DdnsAddRpm.htm?provider=3" --referer "$ip"/ | awk 'c&&c--;/var serInf/{c=3}' | sed 's/[",]//g'
	;;
	
	ports)
		echo "This is a list of the ports that are being forwarded"
		curl -s -u $user:$pwd "$ip/userRpm/VirtualServerRpm.htm" --referer "$ip"/| sed -n "/^var virServerListPara = new Array($/,/^<\/SCRIPT>$/p" | head -n -2 | tail -n +2
	;; 	
	
	logs)
		echo "Displaying logs"
		curl -s -u $user:$pwd "$ip/userRpm/SystemLogRpm.htm?logType=0&logLevel=7&pageNum=1" --referer "$ip"/ | sed -n "/^var logList = new Array($/,/^<\/SCRIPT>$/p" | head -n -1 | tail -n +2| sed 's/[",]//g' 
	;;
	
	info)
		echo "Some information about the Router"
		curl -s -u $user:$pwd "$ip/userRpm/SystemLogRpm.htm?logType=0&logLevel=7&pageNum=1" --referer "$ip"/ | awk 'c&&c--;/var logInf/{c=3}' | sed 's/[",:]//g'
	;;

	wifi)
		echo "WiFi Password"
		curl -s -u $user:$pwd "$ip/userRpm/WlanSecurityRpm.htm" --referer "$ip"/ | awk 'c&&c--;/var wlanPara/{c=1}' | sed 's/[",:]//g' | cut -d " " -f10
	;;
	
	wan)
		echo "WAN Status"
		curl -s -u $user:$pwd "$ip/userRpm/StatusRpm.htm" --referer "$ip"/ | sed -n "/^var wanPara = new Array($/,/^<\/SCRIPT>$/p"| head -n -2 | tail -n +2 | cut -d "," -f 3-4,12-14
	;;
	
	wlan)
		echo "WLAN Status"
		curl -s -u $user:$pwd "$ip/userRpm/StatusRpm.htm" --referer "$ip"/ | sed -n "/^var wlanPara = new Array($/,/^<\/SCRIPT>$/p" | awk 'NR==3,NR==4;NR==6,NR==7'| sed 's/[",]//g' | tr "\n" " "
	;;
	
	help|options)
		echo "pppoe, ddns, logs, info, wifi, wan, wlan, help"
	;;
	
	exit|quit)
		exit 0;
	;;
	
	*)
		echo "Option not found"
	;;

esac
done
