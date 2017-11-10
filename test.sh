#!/bin/bash
TRAFFIC_LIMIT=200
SUM=0
cat test.log | while read line
do
    if [[ ${line} =~ "TRAFFIC-COUNT-TX" ]]
    then
        TEMP=`echo $line | grep ":.*(" -o | grep -o '[0-9]\+'`
        ((SUM=$SUM+$TEMP))
        if [ $SUM -ge $TRAFFIC_LIMIT ]
        then
            echo "exceeded limit"
        fi
    else
        if [[ ${line} =~ "TERMINATED" ]]
        then
            echo "IS TERMINATED"
        fi
    fi

done