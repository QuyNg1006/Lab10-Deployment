#!/usr/bin/env bash
# Exercise 5 - Azure Container Registry + Web App for Containers (run from the Lab10 folder)
set -e
REG="${1:?usage: $0 <unique_registry_name> [location]}"   # lowercase letters/digits only
LOC="${2:-southeastasia}"
RG="rg-lab10"
PLAN="plan-lab10"
APP="webapp-$REG"

az login
az group create -n "$RG" -l "$LOC"
az acr create -n "$REG" -g "$RG" --sku Basic --admin-enabled true
az acr login -n "$REG"

docker build -f MyWebApp/Dockerfile -t myaspnetcoreapp .
docker tag myaspnetcoreapp "$REG.azurecr.io/myaspnetcoreapp:latest"
docker push "$REG.azurecr.io/myaspnetcoreapp:latest"

az appservice plan create -n "$PLAN" -g "$RG" --is-linux --sku B1
az webapp create -n "$APP" -g "$RG" -p "$PLAN" \
  --container-image-name "$REG.azurecr.io/myaspnetcoreapp:latest" \
  --container-registry-url "https://$REG.azurecr.io" \
  --container-registry-user "$(az acr credential show -n "$REG" --query username -o tsv)" \
  --container-registry-password "$(az acr credential show -n "$REG" --query 'passwords[0].value' -o tsv)"
az webapp config appsettings set -n "$APP" -g "$RG" --settings WEBSITES_PORT=8080
echo "Open https://$APP.azurewebsites.net"
# Clean up to avoid charges:  az group delete -n rg-lab10 --yes
