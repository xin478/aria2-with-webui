#!/bin/sh
if [ ! -f /conf/aria2.conf ]; then
	cp /conf-copy/aria2.conf /conf/aria2.conf
	if [ $SECRET ]; then
		echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
	fi
fi
if [ ! -f /conf/on-complete.sh ]; then
	cp /conf-copy/on-complete.sh /conf/on-complete.sh
fi
list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" /conf/aria2.conf`" ]; then
    sed -i '$a bt-tracker='${list} /conf/aria2.conf
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" /conf/aria2.conf
fi

chmod +x /conf/on-complete.sh
touch /conf/aria2.session

darkhttpd /aria2-webui --port 80 &
darkhttpd /data --port 8080 &
aria2c --conf-path=/conf/aria2.conf
