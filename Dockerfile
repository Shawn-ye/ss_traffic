# FROM python:2.7.14-alpine3.6
# RUN pip install shadowsocks
FROM ssbase:latest

COPY start.sh /home
COPY readme /home

WORKDIR /home
CMD ["/bin/sh", "start.sh"]
