#!/usr/bin/env bash
# Exercise 1 & 2 - build, run, manage, push (run from the Lab10 folder)
set -e
DOCKERHUB_USER="${1:?usage: $0 <dockerhub_user>}"

docker --version
docker build -f MyWebApp/Dockerfile -t myaspnetcoreapp .
docker run -d -p 8080:8080 --name myaspnetcoreappcontainer myaspnetcoreapp
echo "Open http://localhost:8080"
docker ps

# Push to Docker Hub (run `docker login` first, with an access token)
docker tag myaspnetcoreapp "$DOCKERHUB_USER/myaspnetcoreapp:latest"
docker push "$DOCKERHUB_USER/myaspnetcoreapp:latest"

# Cleanup when finished:
#   docker stop myaspnetcoreappcontainer && docker rm myaspnetcoreappcontainer
