#!/bin/bash

# rm temp*
docker build -t docker.shawnye.cn:5000/ssbasic:latest .
# docker save shawnye90/shadowsocks:beta -o temp.tar
# echo compressing files
# xz -z temp.tar -0
# scp -P 61022 temp.tar.xz root@sg.shawnye.cn:~
# ssh -p 61022 root@sg.shawnye.cn "xz -d temp.tar.xz && docker load -i temp.tar && rm temp.tar"

# docker run -d --restart=always \
# docker run -i -t \
# -v /root/docker_logs:/home/env \
# -e MODE=ssserver \
# -e PASSWORD="Marzocchi000" -e TRAFFIC_LIMIT=0 \
# -e MAX_IP=0 -p 443:8389 \
# shawnye90/shadowsocks:latest /bin/bash -c "cd home && ./start.sh"




