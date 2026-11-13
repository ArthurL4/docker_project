#!/usr/bin/env bash

# Étape 5 - Result
# Version de Node.js utilisée lors des développements : 18

cd ../result || exit

# Reseau commun
docker network inspect voting-app > /dev/null 2>&1 || docker network create --driver bridge voting-app

# Build de l'image
docker build --tag voting-app-result:1.0.0 .

# Lancement du serveur
docker run \
    --rm \
    --name result \
    --network voting-app \
    -p 8888:8888 \
    -e DATABASE_URL=postgres://postgres:postgres@db/postgres \
    voting-app-result:1.0.0
