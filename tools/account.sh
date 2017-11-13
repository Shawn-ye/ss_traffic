#!/bin/bash

echo Input server address:
read server
echo "Current server is $server"
echo "Specify a port, 60xxx"
read port
echo "Specify a password"
read passwd

cmd="docker run -d --restart=always -v /root/ss_env:/home/env -e MODE=ssserver -e PASSWORD=$passwd -e TRAFFIC_LIMIT=100gb -e MAX_IP=0 -e IP_STAT_INT=60 -p $port:8388 -e TS=`date '+%s'` -e VALID_PERIOD=2678400 shawnye90/shadowsocks:latest /bin/bash -c 'cd home && ./start.sh'"

containerId=`ssh -p 61022 root@$server $cmd`
containerIp=`ssh -p 61022 root@$server "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containerId"`
rule="iptables -I DOCKER -p tcp --syn -d $containerIp --dport 8388 -m connlimit --connlimit-above 20 -j DROP && iptables -L"
ssh -p 61022 root@$server $rule


echo 
echo
echo
echo
echo "---------正式账号----------"
echo "服务器地址:$server"
echo "端口号: $port"
echo "密码: $passwd"
echo "流量: 100gb"
echo "有效期: 31天"
echo "加密方式: AES-256-CFB"
