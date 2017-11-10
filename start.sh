

if [ $MODE == sslocal ]
then
    $MODE -s $SERVER -p $PORT -b $SOCKS_BIND_ADDR -l $SOCKS_PORT -k $PASSWORD
else
    ./eth_stat.sh &
    ./eth_log.sh &
    $MODE -k $PASSWORD
fi


