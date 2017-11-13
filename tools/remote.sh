#!/bin/bash

for id in `docker ps -qa --filter=status=running`
# for id in `docker ps`
# docker ps | while read line
do
    PORT_CONFIG=`docker port $id`
    echo "CONTAINER ID : $id, PORT CONFIG: $PORT_CONFIG"
    cat ss_env/$id*.log | grep "TRAFFIC-COUNT-TX"
    echo
done

