# Base image
FROM python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y git cron procps openssh-client

# Set up SSH for GitHub
# Copy your SSH private key into the container (use build secrets for secure handling)
ARG SSH_PRIVATE_KEY
RUN mkdir -p /root/.ssh && \
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Clone the remote repository
RUN git clone git@github.com-simone:SimoneParvizi/update-counter.git /repo

# Copy your scripts and files into the container
COPY counter.py /repo/
COPY counter.txt /repo/
COPY run.sh /run.sh

# Set permissions for the script
RUN chmod +x /run.sh

# Set up Git configuration
RUN git config --global user.name "Simone Parvizi" && \
    git config --global user.email "parvizi.simone@gmail.com"

# Set up cron job
RUN echo "35 12 * * * /bin/bash /run.sh" > /etc/cron.d/bot-cron && \
    chmod 0644 /etc/cron.d/bot-cron && \
    crontab /etc/cron.d/bot-cron

# Create and set permissions for the log file
RUN touch /var/log/cron.log && chmod 0666 /var/log/cron.log

# Run cron and stream logs
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]
