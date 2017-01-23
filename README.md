# Torque Maui Autorestart
Restarts Torque and Maui services if the scheduler is stalled/locked.

## How to use?
There are two simple scripts and both can be added to a cronjob for routine checks.

### qsub_sanitytest.sh
This will check to see if the job scheduler has stalled but continues to accept job queues.

### pbs_server-scheduler_check.sh
This will check to see if the pbs server or scheduler are still running in the background.

To test either script just them on command line:
./qsub_sanitytest.sh
./pbs_server-scheduler_check.sh

