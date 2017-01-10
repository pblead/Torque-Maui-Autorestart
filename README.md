# Torque Maui Autorestart
Restarts Torque and Maui services if the scheduler is stalled/locked.

# How to use?
Just run the qsub sanity test script:
./qsub_sanitytest.sh

# What does it do?
The script submits a 1 proc and 1 node job to determine if the scheduler is functioning. If a job is queued for a long time because of high load (eg. 100.00%) it will recognize it and stop running.
