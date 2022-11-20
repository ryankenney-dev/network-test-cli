#!/bin/bash

set -e

SCRIPT_FILE="$(basename "$0")"
# NOTE: readlink will not work in OSX
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# If podman available, assume we're using rootless podman
# (no sudo necessary and container root UID is actually host user UID)
if [[ -x "$(command -v podman)" ]]; then
    DOCKER_COMMAND="podman"
    DOCKER_MOUNT_USER="0:0"
# If user in docker unix group, sudo not necessary
elif groups $username | grep -q '\bdocker\b'; then
    DOCKER_COMMAND="docker"
    DOCKER_MOUNT_USER="$(id -u):$(id -g)"
# If user is root, sudo not necessary
elif [[ "$username" == "root" ]]; then
    DOCKER_COMMAND="docker"
    DOCKER_MOUNT_USER="$(id -u):$(id -g)"
# Elso, sudo necessary
else
    DOCKER_COMMAND="sudo docker"
    DOCKER_MOUNT_USER="$(id -u):$(id -g)"
fi

# Build the docker image
$DOCKER_COMMAND build --pull -t "network-test-cli:local-build" .

# Run the docker container
TARGET_FILE="${SCRIPT_FILE}.$(date '+%Y-%m-%d_%H-%M-%S').csv"
$DOCKER_COMMAND run -it --rm \
    --user "$DOCKER_MOUNT_USER" \
    --security-opt label=disable \
    -v "$PWD/target/:/target/:rw" \
    "network-test-cli:local-build" \
    test \
        "https://github.com/ableco/test-files/blob/master/images/test-image-png_4032x3024.png?raw=true" \
        "/target/${TARGET_FILE}"

