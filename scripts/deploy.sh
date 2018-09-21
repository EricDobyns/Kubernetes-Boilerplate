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
FILE=${KUBERNETES_CONFIG_DIR}/applications/$PLATFORM-$ENVIRONMENT/$APPLICATION/$ENVIRONMENT-$APPLICATION-deployment.yaml

# Load version
VERSION=$(jq --arg env "$PLATFORM-$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json) &&
VERSION=$(echo $VERSION | tr -d '"')

# Navigate to the applications directory
cd ${WORKSPACE_DIR}/${APPLICATION}

# Update Version in package.json
jq ".version = \"${VERSION}\"" package.json > package.json.tmp && mv package.json.tmp package.json &&

# Update deployment
kubectl set image deployment/${APPLICATION} ${APPLICATION}=${ARN}:${VERSION} -n ${PLATFORM}-${ENVIRONMENT}

# Get the last commit log
logs=$(git log -1 --pretty=%B origin/staging)

# Navigate to the original directory
cd ${KUBERNETES_CONFIG_DIR}

# DISABLED
# Send Slack notification
#url=https://$ENVIRONMENT-$APPLICATION.hotbdev.com
#node scripts/slackNotification.js "SUCCESS" "*New Build:   $APPLICATION - v$VERSION - $ENVIRONMENT*" "*Link*: $url" "$logs"
