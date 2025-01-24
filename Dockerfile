# Base image
FROM python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y git cron procps

# Install Python dependencies
RUN pip install holidays

# Copy your scripts and files
COPY counter.py .
COPY counter.txt .
COPY run.sh .

# Set permissions
RUN chmod +x /run.sh

# Set up cron job
RUN echo "0 3 * * * /bin/bash /run.sh" > /etc/cron.d/bot-cron
RUN chmod 0644 /etc/cron.d/bot-cron
RUN crontab /etc/cron.d/bot-cron

# Create and set permissions for cron log
RUN touch /var/log/cron.log && chmod 0666 /var/log/cron.log

# Run cron in the foreground and stream logs
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]
