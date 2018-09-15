#!/bin/sh

# Set local constants
PLATFORM=$1
ENVIRONMENT=$2
APPLICATION=$3

# Load version
VERSION=$(jq --arg env "$PLATFORM-$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json)
VERSION=$(echo $VERSION | tr -d '"')
VERSION_ARRAY=($(echo "$VERSION" | tr '.' '\n'))

# Get Major.Minor.Hotfix
MAJOR_VERSION="${VERSION_ARRAY[0]}"; MAJOR_VERSION=${MAJOR_VERSION}
MINOR_VERSION="${VERSION_ARRAY[1]}"; MINOR_VERSION=${MINOR_VERSION}
HOTFIX_VERSION="${VERSION_ARRAY[2]}"; HOTFIX_VERSION=${HOTFIX_VERSION}

# Increment minor version
INCREMENTED_MINOR_VERSION=$(($MINOR_VERSION + 1))

# Concatenate updated version
UPDATED_VERSION=$MAJOR_VERSION"."$INCREMENTED_MINOR_VERSION"."$HOTFIX_VERSION
UPDATED_VERSION_OBJ={\"$APPLICATION\":\"$UPDATED_VERSION\"}

# Update versions.json
echo $(jq --arg env "$PLATFORM-$ENVIRONMENT" --argjson updatedVersion $UPDATED_VERSION_OBJ '.[$env] += $updatedVersion' versions.json) > versions.json
