#!/bin/bash
set -e

# Auto configuration
echo "Running pre-configuration..."
cd /app/config
sh /autoconfig.sh

echo "Starting server..."
cd /app/server
eval java \
    -Dcom.mojang.eula.agree=true \
    -jar /paper/paper.jar \
    --nogui \
    --server-name="${SERVER_NAME:-unknown}" \
    --port="${PORT:-25565}" \
    --max-players="${MAX_PLAYERS:-100}" \
    --bukkit-settings /app/config/bukkit.yml \
    --commands-settings /app/config/commands.yml \
    --spigot-settings /app/config/spigot.yml \
    --config /app/config/server.properties \
    --paper-settings /app/config/paper.yml \
    --world-dir /app/worlds \
    --plugins /app/plugins
