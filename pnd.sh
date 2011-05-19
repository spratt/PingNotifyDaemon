################################################################################
# Ping Notify Daemon
#
# For license information, see file: LICENSE
################################################################################
#!/bin/bash
true=0
false=1
eWasUp=$false
iWasUp=$false
# log script start
echo `date`: pnd started >> /home2bak/spratt/local/var/log/pnd.log
while true
do
    # check external
    ping -q -c 1 google.com > /dev/null 2> /dev/null
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
    ping -q -c 1 ccss.carleton.ca > /dev/null 2> /dev/null
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