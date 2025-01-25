# Base image
FROM python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    cron \
    procps \
    openssh-client \
    curl && \
    apt-get clean

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Set working directory
WORKDIR /repo

# Copy project files
COPY pyproject.toml poetry.lock /repo/

# Install project dependencies with Poetry
RUN poetry config virtualenvs.create false && \
    poetry install --no-root

# Add SSH private key and SSH configuration
ARG SSH_PRIVATE_KEY
ARG SSH_CONFIG
#TODO: remove these echo since they print your ssh
RUN mkdir -p /root/.ssh && \
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_ed25519_simoneparvizi && \
    echo "$SSH_CONFIG" > /root/.ssh/config && \
    chmod 600 /root/.ssh/id_ed25519_simoneparvizi /root/.ssh/config && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts


# Clone the repository using the custom alias
RUN GIT_SSH_COMMAND="ssh -F /root/.ssh/config" git clone git@github.com-simone:SimoneParvizi/update-counter.git /repo

# Copy your scripts and files
COPY counter.py /repo/
COPY counter.txt /repo/
COPY run.sh /run.sh

# Set permissions for the script
RUN chmod +x /run.sh

# Set up cron job
RUN echo "02 9 * * * /bin/bash /run.sh" > /etc/cron.d/bot-cron && \
    chmod 0644 /etc/cron.d/bot-cron && \
    crontab /etc/cron.d/bot-cron

# Create and set permissions for the log file
RUN touch /var/log/cron.log && chmod 0666 /var/log/cron.log

# Run cron and stream logs
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]