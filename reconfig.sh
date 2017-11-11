#!/bin/bash

CONTAINERID=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`
touch pwd/$CONTAINERID
source pwd/$CONTAINERID
