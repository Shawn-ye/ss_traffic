#!/bin/bash

if [ $MODE == sslocal ]
then
    $MODE -s $SERVER -p $PORT -b $SOCKS_BIND_ADDR -l $SOCKS_PORT -k $PASSWORD
else
    CONTAINERID=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`
    touch env/$CONTAINERID.cnf
    source env/$CONTAINERID.cnf

    if [[ $TRAFFIC_LIMIT == 0 ]]
    then
        echo "Traffic limit is set to zero. Statistics will be jumped."
    else
        if [[ $VALID_PERIOD ]]
        then
            :
        else
            $VALID_PERIOD=2678400
        fi
        echo "Valid period is set to $VALID_PERIOD"
        TS_NOW=`date +'%s'`
        ((TS_GAP=$TS_NOW-$TS))
        if [[ $TS_GAP -ge $VALID_PERIOD ]]
        then
            echo "Time expired. Sleep now"
            while [[ true ]]
            do
                sleep 3600
            done
        fi
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
        touch env/$CONTAINERID.log
        cat env/$CONTAINERID.log | while read line
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
    fi

    echo "Current traffic is : $TRAFFIC_COUNT. LIMIT Is : $TRAFFIC_LIMIT"
    ./eth_log.sh &
    ./eth_stat.sh &
    ./time_check.sh &
    cd tcp_proxy
    
    # ping baidu.com > /dev/null 2>&1 &
    $MODE -k $PASSWORD &
    node main.js
fi


