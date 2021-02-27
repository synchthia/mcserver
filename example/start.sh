#!/bin/bash
set -e
cd "$(dirname "$0")"

USER_ID=$(id -u)
GROUP_ID=$(id -g)

mkdir -p $PWD/local
docker-compose up -d
docker attach minecraft
