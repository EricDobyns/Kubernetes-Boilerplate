#!/bin/sh

# Set global constants
WORKSPACE_DIR=/Users/macbookpro/Dock/Repositories/HOTBSoftware/DevOps/workspaces

# Set local constants
PLATFORM=$1
ENVIRONMENT=$2
APPLICATION=$3
ARN=$4

# Get deployment file path
FILE=./applications/$PLATFORM-$ENVIRONMENT/$APPLICATION/$ENVIRONMENT-$APPLICATION-deployment.yaml

# Login to AWS
$(aws ecr get-login --no-include-email --region us-west-1) &&

# TODO: Check if this version already exists in ECR and throw graceful error

# Increment minor version
sh scripts/increment-minor.sh $1 $2 $3 &&

# Load version
VERSION=$(jq --arg env "$PLATFORM-$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json) &&
VERSION=$(echo $VERSION | tr -d '"') &&

echo Deploying version: $VERSION &&

# Update Version in deployment configuration
sed -i.bak "s#${ARN}:.*#${ARN}:${VERSION}#" "${FILE}" &&
rm -rf ${FILE}.bak

# Clean up all unused docker images
docker image prune -a -f &&

# Create container image - TODO: Update path to dockerfile
docker build -t ${APPLICATION} ${WORKSPACE_DIR}/$APPLICATION &&

# Tag and upload new version of the image to AWS-ECR
docker tag ${APPLICATION}:latest ${ARN}:latest &&
docker push ${ARN}:latest &&
docker tag ${APPLICATION}:latest ${ARN}:${VERSION} &&
docker push ${ARN}:${VERSION} &&

# Update deployment
kubectl apply -f "${FILE}" &&

echo Deployment complete.
