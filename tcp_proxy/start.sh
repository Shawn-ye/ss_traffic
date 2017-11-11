#!/bin/bash

tar -cvf files.tar main.js node_modules/
scp -P 61022 files.tar root@sg.shawnye.cn:~
rm files.tar
ssh -p 61022 root@sg.shawnye.cn "cp files.tar proxy/ && rm files.tar && cd proxy/ && tar -xvf files.tar && rm files.tar"
