#!/bin/bash
# Checks the pbs scheduler and server to see if its running.
# Created by pbanh - 20Jan2017

pbsserver_status=$(/etc/init.d/pbs_server status | cut -d" " -f5)
pbssched_status=$(/etc/init.d/pbs_sched status | cut -d" " -f5)

if [ "$pbsserver_status" != "running..." ] || [ "$pbssched_status" != "running..." ] ; then
	
	Time=$(date +[%d/%m/%Y-%T])
	echo "$Time [pbs_check] The server and scheduler is not running... " >> /var/log/messages
	
	/etc/init.d/pbs_server restart
	/etc/init.d/pbs_sched restart

	Time=$(date +[%d/%m/%Y-%T])
	echo "$Time [pbs_check] The server and scheduler was restarted. "

else
	Time=$(date +[%d/%m/%Y-%T])
	echo "$Time [pbs_check] Both the pbs_server and pbs_scheduler are running..." >> /var/log/messages
fi

