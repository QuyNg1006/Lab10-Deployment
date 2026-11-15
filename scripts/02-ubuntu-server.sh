#!/usr/bin/env bash
# Exercise 3 - run ON the Ubuntu server (via SSH)
set -e
DOCKERHUB_USER="${1:?usage: $0 <dockerhub_user>}"

sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker
docker --version

sudo docker pull "$DOCKERHUB_USER/myaspnetcoreapp:latest"
sudo docker rm -f myaspnetcoreappcontainer 2>/dev/null || true
sudo docker run -d -p 8080:8080 --restart unless-stopped \
  --name myaspnetcoreappcontainer "$DOCKERHUB_USER/myaspnetcoreapp:latest"
sudo ufw allow 8080/tcp || true
echo "Open http://<server_ip>:8080"

# Alternative without Docker Hub (from your PC):
#   docker save -o myaspnetcoreapp.tar myaspnetcoreapp
#   scp myaspnetcoreapp.tar user@server_ip:~/
#   (on server) sudo docker load -i ~/myaspnetcoreapp.tar
