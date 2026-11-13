#!/usr/bin/env bash

# Étape 2 - Vote
# Version de Python utilisée lors des développements : 3.11

cd ../vote || exit

# Reseau commun
docker network inspect voting-app > /dev/null 2>&1 || docker network create --driver bridge voting-app

# Build de l'image
docker build --tag voting-app-vote:1.0.0 .

# Lancement du serveur
docker run \
    --rm \
    --name vote \
    --network voting-app \
    -p 8080:8080 \
    -e REDIS_HOST=redis \
    voting-app-vote:1.0.0
