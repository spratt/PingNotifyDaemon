#!/bin/bash
################################################################################
# Ping Notify Daemon
#
# For license information, see file: LICENSE
################################################################################
# CONFIGURATION
internal='ccss.carleton.ca'
external='google.com'
################################################################################
# only modify past this line if you know what you're doing
true=0
false=1
eWasUp=$false
iWasUp=$false
# log script start
declare -i runTime=24
while true
do
    declare -i lastRunTime=runTime
    declare -i runTime=`date +%H`
    if [ $lastRunTime -gt $runTime ]; then
	mv /home2bak/spratt/local/var/log/pnd.log /home2bak/spratt/local/var/log/pnd.log.`date +%s`
	echo `date`: pnd started > /home2bak/spratt/local/var/log/pnd.log
    fi
    # check external
    ping -q -c 1 $external > /dev/null 2> /dev/null
    eIsUp=$?
    # log external
    if [ ! $eWasUp -eq $eIsUp ]; then
	if [ $eIsUp -eq $true ]; then
	    # external came up
	    date=`date`
	    notifyString="external came up"
	    notify-send "$notifyString" "$date"
	    echo $date: $notifyString >> /home2bak/spratt/local/var/log/pnd.log
	    eWasUp=$true
	else
	    # external went down
	    date=`date`
	    notifyString="external went down"
	    notify-send -c "$notifyString" "$date"
	    echo $date: $notifyString >> /home2bak/spratt/local/var/log/pnd.log
	    eWasUp=$false
	fi
    fi
    # check internal
    ping -q -c 1 $internal > /dev/null 2> /dev/null
    iIsUp=$?
    # log internal
    if [ ! $iWasUp -eq $iIsUp ]; then
	if [ $iIsUp -eq $true ]; then
	    # internal came up
	    date=`date`
	    notifyString="internal came up"
	    notify-send "$notifyString" "$date"
	    echo $date: $notifyString >> /home2bak/spratt/local/var/log/pnd.log
	    iWasUp=$true
	else
	    # internal went down
	    date=`date`
	    notifyString="internal went down"
	    notify-send "$notifyString" "$date"
	    echo $date: $notifyString >> /home2bak/spratt/local/var/log/pnd.log
	    iWasUp=$false
	fi
    fi
    # sleep for 30 seconds
    sleep 30
done