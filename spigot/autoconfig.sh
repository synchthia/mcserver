#!/bin/sh
set -e

# Rewrite server.properties
rewriteSettings() {
    local TARGET="server.properties"
    local key=$1
    local value=$2

    if [ "$value" == "" ]; then
        [ "$DEBUG" != "" ] && echo "!! ${key} env has not provided. ignoring..."
        return 0
    fi

    if grep "${key}" "$TARGET" > /dev/null; then
        echo "- Overwrite settings: (${key}: ${value})"
        sed -i "/^${key}\s*=/ c ${key}=${value//\\/\\\\}" "$TARGET"
    else
        echo "- Append settings: (${key}: ${value})"
        echo "${key}=${value}" >> "$TARGET"
    fi
}

rewriteYAML() {
    local TARGET="$1"
    local key=$2
    local value=$3

    if [ "$value" == "" ]; then
        [ "$DEBUG" != "" ] && echo "!! ${key} env has not provided. ignoring..."
        return 0
    fi

    if [ "$(yq e --unwrapScalar=false "${key}" $TARGET)" == "${value}" ]; then
        [ "$DEBUG" != "" ] && echo "!! ${key} env has not provided. ignoring..."
        return 0
    fi

    echo "- Update yaml: (${key}: ${value})"
    yq e -i "${key} = ${value}" $TARGET
}


echo "=> Rewrite settings..."
rewriteSettings "announce-player-achievements" "${NOTIFY_ACHIEVEMENTS}"
rewriteSettings "gamemode" "${GAMEMODE}"
rewriteSettings "level-name" "${LEVEL_NAME}"
rewriteSettings "motd" "${MOTD}"
rewriteSettings "pvp" "${PVP}"
rewriteSettings "allow-flight" "${ALLOW_FLIGHT}"
rewriteSettings "allow-nether" "${ALLOW_NETHER}"
rewriteSettings "difficulty" "${DIFFICULTY}"
rewriteSettings "enable-command-block" "${ENABLE_COMMAND_BLOCK}"
rewriteSettings "generate-structures" "${GENERATE_STRUCTURES}"

if [ "${FLAT}" == "true" ]; then
    rewriteSettings "level-type" "FLAT"
    rewriteSettings "generator-settings" '{"structures"\:{"structures"\:{}},"layers"\:[{"block"\:"minecraft\:air","height"\:1}],"biome"\:"minecraft\:plains","flat_world_options"\:{}}'

else
    rewriteSettings "level-type" "${LEVEL_TYPE}"
    rewriteSettings "generator-settings" "${GENERATOR_SETTINGS}"
fi

rewriteSettings "server-id" "${SERVER_ID}"
rewriteSettings "white-list" "${WHITE_LIST}"
rewriteSettings "online-mode" "${ONLINE_MODE}"
rewriteSettings "spawn-monsters" "${SPAWN_MONSTERS}"
rewriteSettings "spawn-animals" "${SPAWN_ANIMALS}"
rewriteSettings "spawn-npcs" "${SPAWN_NPCS}"

echo "=> Rewrite bukkit.yml..."
rewriteYAML "bukkit.yml" ".settings.allow-end" "${ALLOW_END:-"false"}"

if [ "${BUNGEECORD}" == "true" ]; then
    rewriteYAML "bukkit.yml" ".settings.connection-throttle" "-1"
else
    rewriteYAML "bukkit.yml" ".settings.connection-throttle" "${CONNECTION_THROTTLE:-4000}"
fi

rewriteYAML "bukkit.yml" ".settings.plugin-profiling" "${PLUGIN_PROFILING:-"false"}"

echo "=> Rewrite spigot.yml..."
rewriteYAML "spigot.yml" ".settings.bungeecord" "${BUNGEECORD:-"false"}"

# default => ephemeral (PERSISTENT_PLAYER or PERSISTENT_PLAYER + DISABLE_ADVANCEMENTS...)
if [ "${PERSISTENT_PLAYER}" == "true" ]; then
    rewriteYAML "spigot.yml" ".advancements.disable-saving" "${DISABLE_ADVANCEMENTS:-false}"
    rewriteYAML "spigot.yml" ".players.disable-saving" "${DISABLE_PLAYERS_DATA:-false}"
    rewriteYAML "spigot.yml" ".stats.disable-saving" "${DISABLE_STATS:-false}"
else
    rewriteYAML "spigot.yml" ".advancements.disable-saving" "true"
    rewriteYAML "spigot.yml" ".players.disable-saving" "true"
    rewriteYAML "spigot.yml" ".stats.disable-saving" "true"
fi

echo "=> Rewrite paper.yml..."
rewriteYAML "paper.yml" ".timings.enabled" "${ENABLE_TIMINGS:-false}"
rewriteYAML "paper.yml" ".timings.server-name" "\"${SERVER_NAME:-unknown}\""
rewriteYAML "paper.yml" ".settings.enable-player-collisions" "${PLAYER_COLLISIONS:-false}"

if [ "${VELOCITY}" == "true" ]; then
    rewriteYAML "paper.yml" ".settings.velocity-support.enabled" "true"
    rewriteYAML "paper.yml" ".settings.velocity-support.online-mode" "true"
    rewriteYAML "paper.yml" ".settings.velocity-support.secret" "\"${VELOCITY_SECRET}\""
fi

#rewriteYAML "paper.yml" ".messages.no-permission" "'&cI''m sorry, but you do not have permission to perform this command.'"
