#!/usr/bin/env bash

# Étape 1 - Redis

# Reseau commun
docker network inspect voting-app > /dev/null 2>&1 || docker network create --driver bridge voting-app

docker run \
    --rm \
    --name redis \
    --network voting-app \
    redis:7.2-alpine
