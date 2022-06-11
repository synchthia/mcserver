#!/bin/bash
set -e

echo ":: Downloading latest spigot..."
curl -o BuildTools.jar -fsSL https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
