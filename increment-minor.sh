# Set Constants
ENVIRONMENT=tpa-dev
APPLICATION=tpa-api
ARN=485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api
FILE=./tpa-dev/tpa-api/dev-tpa-api-deployment.yaml

# Load version
VERSION=$(jq --arg env "$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json)
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

# Update versions.json
echo $(jq --arg UPDATED_VERSION $UPDATED_VERSION '."tpa-dev"."tpa-api" = $UPDATED_VERSION' versions.json) > versions.json