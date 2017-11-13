#!/bin/bash

echo "Enter server"
read server

ssh -p 61022 root@$server "./kill.sh $1"
