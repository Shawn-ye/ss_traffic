

if [ $MODE == sslocal ]
then
    $MODE -s $SERVER -p $PORT -b $SOCKS_BIND_ADDR -l $SOCKS_PORT -k $PASSWORD
else
    ./eth_traffic_check.sh
    cd tcp_proxy
    node main.js &
    cd /home
    ./eth_log.sh &
    ./eth_stat.sh &
    # ping baidu.com > /dev/null 2>&1 &
    $MODE -k $PASSWORD
fi


