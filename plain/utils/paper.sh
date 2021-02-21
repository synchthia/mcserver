#!/bin/bash
set -e
cd "$(dirname "$0")"

VERSION="$1"
if [ "$VERSION" == "" ]; then
    echo "Usage: <version>"
    exit 1
fi

echo ":: Retrieve latest builds..."
BUILD=$(curl -fsSL https://papermc.io/api/v2/projects/paper/versions/$VERSION | jq '.builds | max')

echo "-- Detected: $BUILD"

echo ":: Downloading Paper..."
curl -o paper.jar -fsSL https://papermc.io/api/v2/projects/paper/versions/${VERSION}/builds/${BUILD}/downloads/paper-${VERSION}-${BUILD}.jar
