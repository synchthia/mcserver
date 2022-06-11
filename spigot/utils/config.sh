#!/bin/bash
set -e

function setServerProp {
    local prop=$1
    local var=$2
    if [ -n "$var" ]; then
        log "Setting ${prop} to '${var}' in ${SERVER_PROPERTIES}"
        sed -i "/^${prop}\s*=/ c ${prop}=${var//\\/\\\\}" "$SERVER_PROPERTIES"
    else
        log "Skip setting ${prop}"
    fi
}
