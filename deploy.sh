# Set Constants
PLATFORM=tpa
ENVIRONMENT=dev
APPLICATION=tpa-api
ARN=485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api
FILE=./$PROJECT-$ENVIRONMENT/$APPLICATION/$ENVIRONMENT-$APPLICATION-deployment.yaml

# Load version
VERSION=$(jq --arg env "$PLATFORM-$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json) &&
VERSION=$(echo $VERSION | tr -d '"')

echo Deploying version: $VERSION

# Update version in deployment configuration
sed -i '' "s#${ARN}:.*#${ARN}:${VERSION}#" "${FILE}" &&

# Update deployment
kubectl apply -f "${FILE}" &&

echo Deployment complete.