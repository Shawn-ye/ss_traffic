#!/bin/bash

if [[ $TRAFFIC_LIMIT == 0 ]]
then
    echo "Traffic limit is set to zero. Statistics will be jumped."
    exit
else
    if [[ $TRAFFIC_LIMIT =~ .*"gb" ]]
    then
        VALUE=`echo $TRAFFIC_LIMIT | grep -o '[0-9]\+'`
        ((TRAFFIC_LIMIT=$VALUE * 1024 * 1024 * 1024))
    else
        if [[ $TRAFFIC_LIMIT =~ .*"mb" ]]
        then
            VALUE=`echo $TRAFFIC_LIMIT | grep -o '[0-9]\+'`
            ((TRAFFIC_LIMIT=$VALUE * 1024 * 1024))
        fi
    fi
fi

CONTAINERID=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`
mkdir -p logs
touch logs/$CONTAINERID.log

cat logs/$CONTAINERID.log | while read line
do
    if [[ ${line} =~ "TRAFFIC-COUNT-TX" ]]
    then
        TEMP=`echo $line | grep ":.*(" -o | grep -o '[0-9]\+'`
        ((TRAFFIC_COUNT=$TRAFFIC_COUNT+$TEMP))
        if [[ $TRAFFIC_COUNT -ge $TRAFFIC_LIMIT ]]
        then
            echo "Traffic limit exceeded in previous logs. Enter sleep mode"
            while [[ true ]]
            do 
                sleep 3600
            done
        fi
    fi
done

echo "Current traffic is : $TRAFFIC_COUNT. LIMIT Is : $TRAFFIC_LIMIT"



