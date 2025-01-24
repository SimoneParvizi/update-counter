#!/bin/bash
echo "Cron job started at $(date)" >> /var/log/cron.log
/usr/local/bin/python /counter.py >> /var/log/cron.log 2>&1
echo "Cron job completed at $(date)" >> /var/log/cron.log
