#!/bin/bash

apc_status="$(/sbin/apcaccess status 10.10.10.10:3551| 
    grep -e ^LINEV -e ^LOADPCT -e ^BCHARGE -e ^TIMELEFT -e ^BATTV -e ^NUMXFERS -e ^TONBATT| 
        awk '{ printf "%s:", $3}')"

[[ $1 == "-d" ]] && { echo "$apc_status"; exit 0; }

if [[ -z $apc_status ]]; then
    echo "$0: Error: empty \$apc_status" >2
    exit 1
fi

rrdtool update /root/graph-apcupsd/apcupsd.rrd N:"${apc_status:0:-1}"
#echo "${apc_status:0:-1}" >> /root/graph-apcupsd/debug.log
