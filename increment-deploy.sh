# Set Constants
PLATFORM=tpa
ENVIRONMENT=dev
APPLICATION=tpa-api
ARN=485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api
FILE=./$PLATFORM-$ENVIRONMENT/$APPLICATION/$ENVIRONMENT-$APPLICATION-deployment.yaml

# Login to AWS
$(aws ecr get-login --no-include-email --region us-west-1) &&

# TODO: Check if this version already exists in ECR and throw graceful error

# Increment minor version
sh increment-minor.sh &&

# Load version
VERSION=$(jq --arg env "$PLATFORM-$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json) &&
VERSION=$(echo $VERSION | tr -d '"') &&

echo Deploying version: $VERSION &&

# Update Version in deployment configuration
sed -i '' "s#${ARN}:.*#${ARN}:${VERSION}#" "${FILE}" &&

# Clean up all unused docker images
docker image prune -a -f &&

# Create container image - TODO: Update path to dockerfile
docker build -t ${APPLICATION} ../tmp/tpa-api/tpa_service &&

# Tag and upload new version of the image to AWS-ECR
docker tag ${APPLICATION}:latest ${ARN}:latest &&
docker push ${ARN}:latest &&
docker tag ${APPLICATION}:latest ${ARN}:${VERSION} &&
docker push ${ARN}:${VERSION} &&

# Update deployment
kubectl apply -f "${FILE}" &&

echo Deployment complete.