#!/bin/bash

docker build -t shadowsocks:1.0 .
# docker run -v /root/config/ss_server.cnf:/home/config.json --net=host shadowsocks:1.0 /bin/sh -c "ssserver -c /home/config.json"
# docker run -i -t -e MODE=sslocal -e SERVER=sg.shawnye.cn -e PASSWORD="Marzocchi000" -e PORT=443 -e SOCKS_BIND_ADDR=0.0.0.0 -e SOCKS_PORT=8889 --net=host shadowsocks:1.0 /bin/sh -c "cd /home && ./start.sh"
# docker run -i -t -e MODE=ssserver -e PASSWORD="Marzocchi000" -p 443:8388 shadowsocks:1.0 /bin/sh -c "cd /home && ./start.sh"
docker run -i -t -v /root/docker_logs:/home/logs -e MODE=ssserver -e PASSWORD="Marzocchi000" -e TRAFFIC_LIMIT=1024 -p 443:8388 shadowsocks:1.0 /bin/sh
