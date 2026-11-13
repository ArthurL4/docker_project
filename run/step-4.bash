#!/usr/bin/env bash

# Étape 4 - Worker
# Version de .NET Core utilisée lors des développements : 7.0

cd ../worker || exit

# Reseau commun
docker network inspect voting-app > /dev/null 2>&1 || docker network create --driver bridge voting-app

# Build de l'image (restore + publish)
docker build --tag voting-app-worker:1.0.0 .

# Lancement du serveur
docker run \
    --rm \
    --name worker \
    --network voting-app \
    -e REDIS_HOST=redis \
    -e "DB_CONNECTION_STRING=Server=db;Username=postgres;Password=postgres;" \
    voting-app-worker:1.0.0
