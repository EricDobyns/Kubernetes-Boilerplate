# Set Constants
ENVIRONMENT=tpa-dev
APPLICATION=tpa-api
ARN=485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api
FILE=./tpa-dev/tpa-api/dev-tpa-api-deployment.yaml

# Load version
VERSION=$(jq --arg env "$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json) &&
VERSION=$(echo $VERSION | tr -d '"') &&

echo Deploying version: $VERSION

# Update version in deployment configuration
sed -i '' "s#${ARN}:.*#${ARN}:${VERSION}#" "${FILE}" &&

# Update deployment
kubectl apply -f "${FILE}" &&

echo Deployment complete.