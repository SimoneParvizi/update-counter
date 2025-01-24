#!/bin/bash

docker stop contribution-bot
docker rm contribution-bot
docker build --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_ed25519_simoneparvizi)" \
             --build-arg SSH_CONFIG="$(cat ~/.ssh/config)" \
             -t your-image-name .

docker run -d --name contribution-bot contribution-bot
