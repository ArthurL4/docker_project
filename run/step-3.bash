#!/usr/bin/env bash

# Étape 3 - PostgreSQL

# Reseau commun
docker network inspect voting-app > /dev/null 2>&1 || docker network create --driver bridge voting-app

docker run \
    --rm \
    --name db \
    --network voting-app \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=postgres \
    postgres:16.0-alpine
