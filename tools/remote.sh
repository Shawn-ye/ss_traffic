#!/bin/bash

for id in `docker ps -qa --filter=status=running`
do
    PORT_CONFIG=`docker port $id | grep -e ":.*" -o`
    containerip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id`
    TRAFFIC_LIMIT=`docker exec $id /bin/bash -c 'echo "\$TRAFFIC_LIMIT"'`
    if [[ $TRAFFIC_LIMIT =~ .*"not found"* ]]
    then
        echo -e "PORT \033[0;31m$PORT_CONFIG\033[0m, CONTAINER ID : $id"
        echo "Container is NOT running."
        echo 
        continue;
    fi
    start_time=`docker exec $id /bin/bash -c 'echo "\$TS"'`
    time_now=`date '+%s'`
    valid_period=`docker exec $id /bin/bash -c 'echo "\$VALID_PERIOD"'`
    
    #   read logs
    TRAFFIC_COUNT=0
    cat ss_env/$id*.log | while read line
    do
        if [[ ${line} =~ "TRAFFIC-COUNT-TX" ]]
        then
            TEMP=`echo $line | grep ":.*(" -o | grep -o '[0-9]\+'`
            ((TRAFFIC_COUNT=$TRAFFIC_COUNT+$TEMP))
            echo $TRAFFIC_COUNT > .tmp
        fi
    done
    
    TRAFFIC_COUNT=`cat .tmp`
    if [[ $TRAFFIC_COUNT -ge 1048576 ]]
    then
        ((TRAFFIC_COUNT=$TRAFFIC_COUNT / 1048576))
        traffic=`echo $TRAFFIC_COUNT MB`
    else
        traffic=`echo $TRAFFIC_COUNT bytes`
    fi
    echo -e "PORT \033[0;31m$PORT_CONFIG\033[0m, CONTAINER ID : $id, IP : $containerip"
    echo "Traffic : $traffic / $TRAFFIC_LIMIT"

    cnt=0
    echo $cnt > .tmp
    docker exec $id /bin/bash -c 'netstat -apn | grep -e "$containerip:8388"' | while read line
    do
        # echo $line
        echo $line
        if [[ $line =~ .*"ESTABLISHED".* ]]
        then
            ((cnt=$cnt + 1))
            echo $cnt > .tmp    
        fi
    done

    echo Active connections: `cat .tmp`

    if [[ $TRAFFIC_LIMIT != 0 ]]
    then
        #   Remaining time
        ((remain_sec=$start_time + $valid_period - $time_now))
        ((days=$remain_sec / 86400))
        ((temp=$remain_sec - 86400 * $days))
        ((hours=$temp / 3600))
        ((temp2=$temp - $hours * 3600))
        ((min=$temp2 / 60))
        echo "Time remained: $days day $hours hours $min mins."
    fi

    echo
done

