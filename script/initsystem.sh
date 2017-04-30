#!/bin/bash

. ./config.cfg

cd `dirname $0`

echo Enter sudo password
stty -echo
read SUDOPW
stty echo

function serverProc {
    echo $SUDOPW | ssh -tt $1 sudo 'sh -c "mkdir -p /var/tmp/robocup ; chmod 777 /var/tmp/robocup"' | sed 1,2d
    ssh $1 mkdir -p /var/tmp/robocup/$2
    scp -r ../roborescue ${1}:/var/tmp/robocup/$2/roborescue
}

function clientProc {
    echo $SUDOPW | ssh -tt $1 sudo 'sh -c "mkdir -p /var/tmp/robocup ; chmod 777 /var/tmp/robocup"' | sed 1,2d
    ssh $1 mkdir -p /var/tmp/robocup/$2
}

serverProc $SERVER_SS S
clientProc $SERVER_C1 1
clientProc $SERVER_C2 2
clientProc $SERVER_C3 3

SUDOPW=""
