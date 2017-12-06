
if [ "$PASSWORD" = "" ];
then
    cat readme
    exit
fi

if [ "$MODE" = "1" ]
then
    ssserver -k $PASSWORD
else
    if [ "$PORT" = "" ]
    then
        PORT=443
    fi

    sslocal -s $SERVER -p $PORT -b 0.0.0.0 -l 1234 -k $PASSWORD    
fi


