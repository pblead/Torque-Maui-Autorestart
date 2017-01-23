# Torque Maui Autorestart
Restarts Torque and Maui services if the scheduler is stalled/locked.

## How to use?
Here are two simple scripts that check on the pbs server and scheduler; both can be added to a cronjob for routine checks.

### qsub_sanitytest.sh
This will check to see if the job scheduler has stalled but continues to accept job queues.

### pbs_server-scheduler_check.sh
This will check to see if the pbs server or scheduler are still running in the background.

To test either script just them on command line:
./qsub_sanitytest.sh
./pbs_server-scheduler_check.sh

