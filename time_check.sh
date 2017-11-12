#!/bin/bash

if [[ $TRAFFIC_LIMIT == 0 ]]
then
    exit
else
    while [[ true ]]
    do
        TS_NOW=`date +'%s'`
        ((TS_GAP=$TS_NOW-$TS))
        if [[ $TS_GAP -ge $VALID_PERIOD ]]
        then
            echo "Time expired. Kill process."
            pkill -f $MODE
        fi
        sleep 60
    done
fi
