if [[ $TRAFFIC_LIMIT == 0 ]]
then
    echo "Traffic limit is set to 0 . Ignore traffic statistics."
    exit
else
    echo "CURRENT TRAFFIC LIMIT IS : $TRAFFIC_LIMIT"
fi

CONTAINERID=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`
mkdir -p logs
touch logs/$CONTAINERID.log



#   Begin analysis
echo -----------BEGIN TRAFFIC STATISTICS----------- >> logs/$CONTAINERID.log
echo -----------IGNORE----------- >> logs/$CONTAINERID.log
while [[ true ]]
do
    NET=`ifconfig eth0`
    STRING=`echo ${NET} | grep -e "TX bytes:.*)" -o`
    sed -i '$d' logs/$CONTAINERID.log
    echo -----------${STRING}----------- >> logs/$CONTAINERID.log
    # echo ${STRING} | cut -d "(" -f1
    sleep 10
done


