#!/bin/sh

# Set local constants
PLATFORM=$1
ENVIRONMENT=$2
APPLICATION=$3
ARN=$4

# Get deployment file path
FILE=./applications/$PLATFORM-$ENVIRONMENT/$APPLICATION/$ENVIRONMENT-$APPLICATION-deployment.yaml

# Load version
VERSION=$(jq --arg env "$PLATFORM-$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json) &&
VERSION=$(echo $VERSION | tr -d '"')

echo Deploying version: $VERSION

# Update version in deployment configuration
sed -i '' "s#${ARN}:.*#${ARN}:${VERSION}#" "${FILE}" &&

# Update deployment
kubectl apply -f "${FILE}" &&

echo Deployment complete.
