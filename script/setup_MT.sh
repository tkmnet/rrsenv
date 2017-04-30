#!/bin/bash

. `dirname ${OACIS_WORKDIR}`/config.cfg

MAP=$1
FTEAM=$2
PTEAM=$3
ATEAM=$4
DATECODE=`date +%y%m%d`
EXITCODE=0

cd `dirname $0`


function serverProc {
    ssh $1 mkdir -p /var/tmp/robocup/$2/MAP
    ssh $1 rm -rf /var/tmp/robocup/$2/MAP/${MAP}
    scp -r ../MAP/${MAP} ${1}:/var/tmp/robocup/$2/MAP/
    ssh $1 mkdir -p /var/tmp/robocup/$2/LOG/${DATECODE}-${MAP}
    if `ssh $1 test ! -e /var/tmp/robocup/$2/LOG/${DATECODE}-${MAP}/${DATECODE}-${MAP}.tar` ; then
        ssh $1 sh -c "'cd /var/tmp/robocup/$2/MAP; tar cvf /var/tmp/robocup/$2/LOG/${DATECODE}-${MAP}/${DATECODE}-${MAP}.tar ${MAP}'"
    fi
}

function clientProc {
    ssh $1 mkdir -p /var/tmp/robocup/$2/TEAM
    ssh $1 rm -rf /var/tmp/robocup/$2/TEAM/$3
    scp -r ../TEAM/$3 ${1}:/var/tmp/robocup/$2/TEAM/
    ssh $1 chmod a+x /var/tmp/robocup/$2/TEAM/$3/*.sh
    ssh $1 sh -c "\"cd /var/tmp/robocup/$2/TEAM/$3 ; bash ./compile.sh\""
    EXITCODE=`echo $? $EXITCODE |awk '{print $1 + $2;}'`
}

serverProc $SERVER_SS S
clientProc $SERVER_C1 1 $FTEAM
clientProc $SERVER_C2 2 $PTEAM
clientProc $SERVER_C3 3 $ATEAM

exit $EXITCODE