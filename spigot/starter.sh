#!/bin/bash
set -e

# Auto configuration
echo "Running pre-configuration..."
cd /app/config
sh /autoconfig.sh

echo "Starting server..."
cd /app/server
exec java \
    -Dcom.mojang.eula.agree=true \
    -jar /spigot/spigot.jar \
    --nogui \
    --port="${PORT:-25565}" \
    --max-players="${MAX_PLAYERS:-100}" \
    --bukkit-settings /app/config/bukkit.yml \
    --commands-settings /app/config/commands.yml \
    --spigot-settings /app/config/spigot.yml \
    --config /app/config/server.properties \
    --world-dir /app/worlds \
    --plugins /app/plugins
