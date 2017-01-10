#!/bin/bash
# Sanity check for Torque/Maui qsub command job submissions.
# Created by pbanh - 10Jan2017

Jobid=$(echo "sleep 30" | /usr/local/bin/qsub -N SanityTest -o /dev/null -e /dev/null | grep -v "null" | cut -d. -f1)
# Wait Time to ensure intial queued job isn't grabbed 
sleep 10	
Jobcheck=$(/usr/local/bin/qstat | grep $Jobid)
Jobtus=$(echo $Jobcheck | cut -d" " -f5)
# Check to see if the job is running.
# Default one core and 1 node, should work most the Time.
if [ ! -z "$Jobcheck" ] && [ "$Jobtus" = "R" ]; then

	Time=$(date +[%d/%m/%Y-%T])
	echo "$Time [Qsub Sanity] Sanity Job is running..."
# Waiting for the job to end  			
	sleep 60	
	Jobrecheck=$(/usr/local/bin/qstat | grep $Jobid)

	if [ -z "$Jobrecheck" ];
	then
		Time=$(date +[%d/%m/%Y-%T])
		echo "$Time [Qsub Sanity] The scheduler is active..."
		exit 0
	fi 

# Check to see if all Nodes are taken.
# If active Nodes are not at 100%, it has to investigate further.

# If 100% the sanity check will wait, if jobs continue to stall it has to be invesitgated.
elif [ ! -z "$Jobcheck" ] && [ "$Jobtus" = "Q" ];
then
	Time=$(date +[%d/%m/%Y-%T])	
	echo "$Time [Qsub Sanity] Sanity Job is queued..."		
	Nodes=$(showq | grep "Nodes Active" | sed -e 's/^[ \t]*//' | cut -d" " -f13)

	if [ "$Nodes" = "(100.00%)" ]; then
		Time=$(date +[%d/%m/%Y-%T])
		echo "$Time [Qsub Sanity] All Nodes are taken...sanity test exiting..."
		exit 0		
	else
		Time=$(date +[%d/%m/%Y-%T])
		echo "$Time [Qsub Sanity] Waiting to check sanity job again..."
		# Wait 30 mins to see if the scheduler is just slow/lagging.
		sleep 1800
		Jobrecheck=$(/usr/local/bin/qstat | grep $Jobid)
		Jobtus=$(echo $Jobrecheck | cut -d" " -f5)
		#Jobtus=$(echo $Jobcheck | cut -d" " -f5)
		Nodes=$(showq | grep "Nodes Active" | sed -e 's/^[ \t]*//' | cut -d" " -f13)
			
		echo "$Jobtus $Nodes"
		# Checking to see if the job is still just queued.
		# If the job is still queued, another sanity test will be done.
		if [ "$Jobtus" = "Q" ] && [ "$Nodes" != "(100.00%)" ]; then
			Time=$(date +[%d/%m/%Y-%T])
			echo "$Time [Qsub Sanity] Sanity test is stalling..."
			echo "$Time [Qsub Sanity] Starting another sanity test..."
			Secondjob=$(echo "sleep 30" | /usr/local/bin/qsub -N SanityTest -o /dev/null -e /dev/null | grep -v "null" | cut -d. -f1)
			#sleep 10
			Secondcheck=$(/usr/local/bin/qstat | grep $Secondjob)
			Secondtus=$(echo $Secondcheck | cut -d" " -f5)
			Nodes=$(showq | grep "Nodes Active" | sed -e 's/^[ \t]*//' | cut -d" " -f13)
			
			# Wait 5 minutes before checking on the second sanity job.			
			sleep 300

			# Check to see if the second job went through.
			# Check ends if second job finishes.
			if [ ! -z "$Secondcheck" ] && [ "$Secondtus" = "Q" ] && [ "$Nodes" != "(100.00%)" ]; then
				Time=$(date +[%d/%m/%Y-%T])
				echo "$Time [Qsub Sanity] The second sanity test is stalling..."
				echo "$Time [Qsub Sanity] Torque scheduler and Maui will be restarted..."
				
				# Restart the Torque scheduler and Maui
				/etc/init.d/maui.d stop
				/etc/init.d/pbs_server restart
				/etc/init.d/pbs_sched restart
				/etc/init.d/maui.d start
			else
				Time=$(date +[%d/%m/%Y-%T])
				echo "$Time [Qsub Sanity] The scheduler is active..."		
				exit 0 
			fi
		fi
	fi	
fi

Time=$(date +[%d/%m/%Y-%T])
echo "$Time [Qsub Sanity] The scheduler is active..."		
exit 0 

