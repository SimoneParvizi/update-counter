#!/bin/bash

echo "Stopping the container"
docker stop contribution-bot
echo "Removing the container"
docker rm contribution-bot
docker build --no-cache --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_ed25519_simoneparvizi)" \
             --build-arg SSH_CONFIG="$(cat ~/.ssh/config)" \
             -t contribution-bot .

docker run -d --name contribution-bot contribution-bot
