#!/bin/bash
cd "$(dirname "$0")"

mkdir -p local
docker run --rm --name mc-lobby \
    -p 25571:25565 \
    -e PORT=25555 \
    -e UID=$(id -u) \
    -v $PWD/local/config:/app/config \
    -v $PWD/local/plugins:/app/plugins \
    -v $PWD/local/worlds:/app/worlds \
    --entrypoint /bin/bash \
    -it startail/mcserver:plain
