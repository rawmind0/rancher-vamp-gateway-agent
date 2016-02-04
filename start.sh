#!/usr/bin/env bash

set -e

function log {
    echo `date` $ME - $@
}

function checkrancher {
    log "checking rancher network..."
    a="1"
    while  [ $a -eq 1 ];
    do
        a="`ip a s dev eth0 &> /dev/null; echo $?`" 
        sleep 1
    done

    b="1"
    while [ $b -eq 1 ]; 
    do
        b="`ping -c 1 rancher-metadata &> /dev/null; echo $?`"
        sleep 1 
    done
}

VAMP_LOG_SERVER=${VAMP_LOG_SERVER:-"logstash"} # elasticsearch or in-memory (no persistence)
VAMP_KEY_TYPE=${VAMP_KEY_TYPE:-"zookeeper"}  # zookeeper, etcd or consul
VAMP_KEY_SERVERS=${VAMP_KEY_SERVERS:-"zookeeper:2181"}
   
checkrancher

export VAMP_LOG_SERVER VAMP_KEY_TYPE VAMP_KEY_SERVERS 

log "[ Starting vamp gateway agent... ]"
/opt/vamp/vamp-gateway-agent --logo=false --logstashHost=${VAMP_LOG_SERVER} --storeType=${VAMP_KEY_TYPE} --storeConnection=${VAMP_KEY_SERVERS}
