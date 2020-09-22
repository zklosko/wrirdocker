#!/bin/bash

# Boilerplate from https://blog.knoldus.com/running-a-cron-job-in-docker-container/

# Start the run once job.
echo "Docker container has been started"
bash scripts/lsdb2.sh 

# Setup a cron schedule
# By the way...
# * * * * * command(s)
# - - - - -
# | | | | |
# | | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
# | | | ------- Month (1 - 12)
# | | --------- Day of month (1 - 31)
# | ----------- Hour (0 - 23)
# ------------- Minute (0 - 59)
echo "0 * * * * /scripts/lsdb2.sh >> /var/log/cron.log 2>&1
0 4 1 * * /scripts/deleteoldshows.sh >> /var/log/cron.log 2>&1
55 * * * * /scripts/wan-traffic.sh >> /var/log/cron.log 2>&1
# This extra line makes it a valid cron" > scheduler.txt

crontab scheduler.txt
cron -f