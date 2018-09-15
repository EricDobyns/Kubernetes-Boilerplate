#!/bin/sh

# Set global constants
WORKSPACE_DIR=/home/ec2-user/workspaces
KUBERNETES_CONFIG_DIR=/home/ec2-user/hotb-kubernetes

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

## Notification Steps
# Navigate to the applications directory
cd ${WORKSPACE_DIR}/${APPLICATION}

# Get the last commit log
logs=$(git log -1 --pretty=%B origin/staging)

# Navigate to the original directory
cd ${KUBERNETES_CONFIG_DIR}

# Send Slack notification
url=https://$ENVIRONMENT-$APPLICATION.hotbdev.com
node scripts/slackNotification.js "SUCCESS" "*New Build:   $APPLICATION - v$VERSION - $ENVIRONMENT*" "*Link*: $url" "$logs"
