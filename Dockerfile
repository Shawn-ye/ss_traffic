FROM python:2.7.14-alpine3.6
# RUN apt-get update && apt-get install -y python 
# RUN apt-get install wget -y
# RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
RUN pip install shadowsocks
# RUN apt-get install net-tools
RUN apk add --update bash && rm -rf /var/cache/apk/* && apk add --update nodejs
# RUN apk add nodejs

COPY tcp_proxy/ /home/tcp_proxy/
COPY eth_traffic_check.sh /home/eth_traffic_check.sh
COPY eth_stat.sh /home/eth_stat.sh
COPY start.sh /home/start.sh
COPY eth_log.sh /home/eth_log.sh
COPY reconfig.sh /home/reconfig.sh
COPY time_check.sh /home/time_check.sh
ENV TRAFFIC_COUNT 0
