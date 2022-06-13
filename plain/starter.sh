#!/bin/bash
set -e

# Make symbolic link (for compatibility)
echo "Make link: worlds"
cd /app/worlds
for d in $(find . -mindepth 1 -maxdepth 1 -type d -printf '%P\n'); do
    ln -sv ${PWD}/$d /app/server/$d
done

echo "Make link: config"
cd /app/config
for f in $(find . -mindepth 1 -maxdepth 1 -type f -printf '%P\n'); do
    ln -sv ${PWD}/$f /app/server/$f
done

# Auto configuration
echo "Running pre-configuration..."
cd /app/config
sh /autoconfig.sh

echo "Starting server..."
cd /app/server
exec java \
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
