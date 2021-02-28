#!/bin/bash
set -e
cd "$(dirname "$0")"

# Set container user
USER_ID=`id -u`
GROUP_ID=`id -g`

function _start() {
    mkdir -p $PWD/local

    echo ":: Starting container..."
    docker-compose up -d

    echo ":: Attach console (exit: Ctrl+P, Ctrl+Q)"
    docker attach minecraft
}

function _stop() {
    echo ":: Stopping container..."
    docker-compose down
}

if [ "$1" = "start" ]; then
    _start
elif [ "$1" = "stop" ]; then
    _stop
else
    echo "Usage: launcher <start|stop>"
    exit 1
fi
