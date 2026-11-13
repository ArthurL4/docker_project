#!/usr/bin/env bash

# Remets le projet dans son état initial

cd ..

# Stack compose + volumes
docker compose down --volumes --remove-orphans

# Conteneurs et reseau des scripts
docker container stop redis vote db worker result > /dev/null 2>&1
docker network rm voting-app > /dev/null 2>&1

# Images construites
docker image rm voting-app-vote:1.0.0 voting-app-worker:1.0.0 voting-app-result:1.0.0 > /dev/null 2>&1

exit 0
