#!/bin/bash

# Navigate to the Git repository
cd /repo || exit

echo "Cron job started at $(date)" >> /var/log/cron.log

# Run the Python script to update the counter
/usr/local/bin/python /repo/counter.py >> /var/log/cron.log 2>&1

# Add and commit changes
git add /repo/counter.txt >> /var/log/cron.log 2>&1
git commit -m "Update counter: $(date)" >> /var/log/cron.log 2>&1
git push origin main >> /var/log/cron.log 2>&1

echo "Cron job completed at $(date)" >> /var/log/cron.log

#