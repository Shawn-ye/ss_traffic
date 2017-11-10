#!/bin/bash
if [[ $TRAFFIC_LIMIT == 0 ]]
then
    echo "Traffic limit is set to zero. Statistics will be jumped."
    exit
fi


CONTAINERID=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`
#   Begin analysis
echo -----------BEGIN TRAFFIC STATISTICS----------- >> logs/$CONTAINERID.log
echo -----------IGNORE----------- >> logs/$CONTAINERID.log
while [[ true ]]
do
    NET=`ifconfig eth0`
    STRING=`echo ${NET} | grep -e "TX bytes:.*)" -o`

    sed -i '$d' logs/$CONTAINERID.log
    echo TRAFFIC-COUNT-${STRING}----------- >> logs/$CONTAINERID.log
    TEMP=`echo ${STRING} | grep -e "TX bytes:.*(" -o | grep -o '[0-9]\+'`

    TEMPSUM=$(expr $TRAFFIC_COUNT + $TEMP)
    # echo "Current traffic : $TEMPSUM"
    if [[ $TEMPSUM -ge $TRAFFIC_LIMIT ]]
    then
        echo "Traffic limit exceeded now, KILL process."
        pkill -f $MODE
    fi
    sleep 10
done



