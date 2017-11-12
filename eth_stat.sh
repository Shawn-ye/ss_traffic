#!/bin/bash

CONTAINERID=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`
#   Begin analysis
echo -----------BEGIN TRAFFIC STATISTICS----------- >> env/$CONTAINERID.log
echo -----------IGNORE----------- >> env/$CONTAINERID.log
while [[ true ]]
do
    NET=`ifconfig eth0`
    STRING=`echo ${NET} | grep -e "TX bytes:.*)" -o`

    sed -i '$d' env/$CONTAINERID.log
    echo TRAFFIC-COUNT-${STRING}----------- >> env/$CONTAINERID.log
    TEMP=`echo ${STRING} | grep -e "TX bytes:.*(" -o | grep -o '[0-9]\+'`

    TEMPSUM=$(expr $TRAFFIC_COUNT + $TEMP)
    if [[ $TRAFFIC_LIMIT != 0 ]]
    then
        if [[ $TEMPSUM -ge $TRAFFIC_LIMIT ]]
        then
            echo "Traffic limit exceeded now, KILL process."
            pkill -f $MODE
        fi
    fi
    sleep 10
done



