#!/bin/bash

set -e

if [[ -z "$(which docker)" ]]; then
    echo "error: docker is not installed!"
    exit 1
fi

# clean docker containers
if [[ ! -z $(docker ps -aq -f "status=exited") ]]; then
    docker rm $(docker ps -aq -f "status=exited")
fi

# clean docker volumes
if [[ ! -z $(docker volume ls -q) ]]; then
    docker volume rm $(docker volume ls -q)
fi

# clean untagged docker images
if [[ ! -z $(docker images -q -f dangling=true) ]]; then
    docker rmi $(docker images -q -f dangling=true)
fi
