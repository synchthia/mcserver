#!/bin/bash
set -e
cd "$(dirname $0)"

## prepare - copy files from templates
_task_prepare() {
    _world() {
        # Make symbolic link (for compatibility)
        echo "Make link: worlds"
        cd /app/worlds

        # default world
        ln -sfnv ${PWD}/${LEVEL_NAME:-world} /app/server/${LEVEL_NAME:-world}

        # nether
        if [ "$ALLOW_NETHER" = "true" ]; then
            ln -sfnv ${PWD}/${LEVEL_NAME:-world}_nether /app/server/${LEVEL_NAME:-world}_nether
        fi

        # end
        if [ "$ALLOW_END" = "true" ]; then
            ln -sfnv ${PWD}/${LEVEL_NAME:-world}_the_end /app/server/${LEVEL_NAME:-world}_the_end
        fi

        # other worlds
        for target in $(find . -mindepth 1 -maxdepth 1 | sed -e 's/\.\///'); do
            ln -sfnv ${PWD}/${target} /app/server/${target}
        done
    }

    _template() {
        # Copy from templates directory
        echo "Make from template"
        cd /app/templates

        # config
        cd ./config
        for target in $(find . -mindepth 1 -maxdepth 1 | sed -e 's/\.\///'); do
            cp -Rpnv ${PWD}/${target} /app/config/${target}
        done

        # plugins
        cd ../plugins
        for target in $(find . -mindepth 1 -maxdepth 1 | sed -e 's/\.\///'); do
            ln -sfnv ${PWD}/${target} /app/plugins/${target}
        done
    }

    _world
    _template
}

## start - start server
_task_start() {
    _task_prepare

    # Auto configuration
    echo "Running pre-configuration..."
    cd /app/config
    sh /autoconfig.sh

    echo "Starting server..."
    cd /app/server
    exec java \
        -jar /paper/paper.jar \
        --nogui \
        --server-name="${SERVER_NAME:-unknown}" \
        --port="${PORT:-25565}" \
        --max-players="${MAX_PLAYERS:-100}" \
        --bukkit-settings /app/config/bukkit.yml \
        --commands-settings /app/config/commands.yml \
        --spigot-settings /app/config/spigot.yml \
        --config /app/config/server.properties \
        --paper-dir /app/config/paper \
        --world-dir /app/worlds \
        --plugins /app/plugins
}

if [ "$1" == "" ] && [ "$2" == "" ]; then
    cmds="$(cat $0 | grep -E '^(_task).*\{$' | sort | tr -d '\ (){}' | tr '\n' '|' | sed -e 's/_task_//g' -e 's/|$/\n/g')"
    echo -e "Usage: $0 <${cmds}> [options...]"
    exit 1
fi

_args=$(shift 1 && echo $@)
_task_$1 $_args
