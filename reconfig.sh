#!/bin/bash

CONTAINERID=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`
touch env/$CONTAINERID.cnf
source env/$CONTAINERID.cnf
