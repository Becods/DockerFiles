#!/bin/sh

for i in `cat /.env`;do
	socatport=`echo $i|awk -F',' '{print $1}'`
	sourceserver=`echo $i|awk -F',' '{print $2}'`
	xrayport=`echo $i|awk -F',' '{print $3}'`
	xrayconf=`echo $i|awk -F',' '{print $4}'`
	nohup /usr/bin/xray run ${xrayconf} > /xray_${xrayport}_log.out 2>&1 &
	nohup /usr/bin/socat -d TCP4-LISTEN:${socatport},reuseaddr,fork SOCKS5:127.0.0.1:${sourceserver},socks5port=${xrayport} > /socket_${socatport}_log.out 2>&1 &
	echo "[Info] "${xrayconf}","${xrayport}","${socatport}"创建成功"
done

while true;do
	sleep 60s
done
