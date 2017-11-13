#!/bin/bash

for server in `cat servers`
do
    if [[ $1 ]]
    then
        scp -P 61022 remote.sh root@$server:~/.temp.sh
    fi
    echo "--------------HOST: $server --------------"
    ssh root@$server -p 61022 "chmod +x .temp.sh && ./.temp.sh"
done
