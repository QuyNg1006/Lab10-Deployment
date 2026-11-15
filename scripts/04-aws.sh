#!/usr/bin/env bash
# Exercise 6 - Amazon ECR (+ Elastic Beanstalk via console using Dockerrun.aws.json)
set -e
REGION="${1:?usage: $0 <region> <aws_account_id>}"
ACCT="${2:?usage: $0 <region> <aws_account_id>}"
REPO="myaspnetcoreapp"
URI="$ACCT.dkr.ecr.$REGION.amazonaws.com/$REPO"

aws configure     # enter Access Key / Secret once
aws ecr create-repository --repository-name "$REPO" --region "$REGION" || true
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ACCT.dkr.ecr.$REGION.amazonaws.com"

docker build -f MyWebApp/Dockerfile -t myaspnetcoreapp .
docker tag myaspnetcoreapp "$URI:latest"
docker push "$URI:latest"
echo "Now create an Elastic Beanstalk 'Web server environment' (platform: Docker) and upload Dockerrun.aws.json"
