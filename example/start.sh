#!/bin/bash
set -e
cd "$(dirname "$0")"

mkdir -p $PWD/local
docker-compose up -d
docker attach minecraft
