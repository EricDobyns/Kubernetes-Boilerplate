#!/bin/sh

# Set hard constants
WORKSPACE_DIR=
KUBERNETES_CONFIG_DIR=
DOMAIN_NAME=

# Import constants
PLATFORM=$1
ENVIRONMENT=$2
APPLICATION=$3
ARN=$4

# Get deployment file path
FILE=${KUBERNETES_CONFIG_DIR}/application-scripts/$PLATFORM-$ENVIRONMENT/$APPLICATION/$ENVIRONMENT-$APPLICATION-deployment.yaml

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

# DISABLED - Uncomment if needed
# Send Slack notification
# url=https://$ENVIRONMENT-$APPLICATION.$DOMAIN_NAME.com
# node deployment-scripts/slackNotification.js "SUCCESS" "*New Build:   $APPLICATION - v$VERSION - $ENVIRONMENT*" "*Link*: $url" "$logs"
