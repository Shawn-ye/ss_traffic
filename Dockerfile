FROM python:2.7.14-alpine3.6
RUN pip install shadowsocks
COPY eth_stat.sh /home/eth_stat.sh
COPY start.sh /home/start.sh
COPY eth_log.sh /home/eth_log.sh
