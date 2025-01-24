# Base image
FROM python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y git cron

# Install Python dependencies
RUN pip install holidays

# Copy your scripts and files
COPY counter.py .
COPY counter.txt .
COPY run.sh .

# Set permissions and install dependencies
RUN chmod +x /run.sh

# Set up cron job
RUN echo "* * * * * /bin/bash /run.sh" > /etc/cron.d/bot-cron
RUN chmod 0644 /etc/cron.d/bot-cron
RUN crontab /etc/cron.d/bot-cron

# Git configuration (add your SSH key or use personal access tokens)
ARG GITHUB_USER
ARG GITHUB_TOKEN
RUN git config --global user.name "$GITHUB_USER" && \
    git config --global user.email "$GITHUB_USER@example.com"

# Run cron in the foreground
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]
