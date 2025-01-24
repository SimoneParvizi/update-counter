#!/bin/bash

docker stop contribution-bot
docker rm contribution-bot
docker build -t contribution-bot .
docker run -d --name contribution-bot contribution-bot
