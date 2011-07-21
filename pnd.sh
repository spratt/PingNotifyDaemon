#!/bin/bash
################################################################################
# Ping Notify Daemon
#
# For project information, see file: README
# For license information, see file: LICENSE
################################################################################
# CONFIGURATION
internal='ccss.carleton.ca'
external='google.com'
log='/home2bak/spratt/local/var/log/pnd.log'
################################################################################
# only modify past this line if you know what you're doing
true=0
false=1
# log script start
declare -i timeWentDown=0
declare -i timeCameUp=0
declare -i downTime=0
declare -i totalDownTime=0
declare -i runTime=24
function ping_external() {
    ping -q -c 1 $external > /dev/null 2> /dev/null
}
function ping_internal() {
    ping -q -c 1 $internal > /dev/null 2> /dev/null
}
while sleep 5; do
    # save the last runtime and determine the hour of the day
    declare -i lastRunTime=runTime
    runTime=`date +%k`
    # if the hour of the day is less than the previous hour,
    # midnight was just passed so archive yesterday's log
    if [ $lastRunTime -gt $runTime ]; then
	if [ -e $log ]; then
	    mv $log $log.`date +%s`
	fi
	echo `date`: pnd started > $log
	totalDownTime=0
	timeWentDown=0
	eWasUp=$false
	iWasUp=$false
    fi
    # check external
    ping_external || ping_external || ping_external
    eIsUp=$?
    # log external
    if [ ! $eWasUp -eq $eIsUp ]; then
	if [ $eIsUp -eq $true ]; then
	    # external came up
	    date=`date`
	    timeCameUp=`date +%s`
	    notifyString="external came up"
	    notify-send "$notifyString" "$date"
	    echo $date: $notifyString >> $log
	    if [ $timeWentDown -gt 0 ]; then
		downTime=$((timeCameUp - timeWentDown))
		totalDownTime=$(( totalDownTime + downTime))
		echo Network was down for $downTime seconds >> $log
		echo Total downtime today: $totalDownTime seconds >> $log
	    fi
	    eWasUp=$true
	else
	    # external went down
	    date=`date`
	    timeWentDown=`date +%s`
	    notifyString="external went down"
	    notify-send "$notifyString" "$date"
	    echo $date: $notifyString >> $log
	    echo =============== BEGIN TRACEROUTE ============== >> $log
	    tr.sh $external 15 >> $log
	    echo === TRACEROUTE ENDED AT `date` === >> $log
	    eWasUp=$false
	fi
    fi
    ping_internal || ping_internal || ping_internal
    iIsUp=$?
    # log internal
    if [ ! $iWasUp -eq $iIsUp ]; then
	if [ $iIsUp -eq $true ]; then
	    # internal came up
	    date=`date`
	    notifyString="internal came up"
	    notify-send "$notifyString" "$date"
	    echo $date: $notifyString >> $log
	    iWasUp=$true
	else
	    # internal went down
	    date=`date`
	    notifyString="internal went down"
	    notify-send "$notifyString" "$date"
	    echo $date: $notifyString >> $log
	    iWasUp=$false
	fi
    fi
done
