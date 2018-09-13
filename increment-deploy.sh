# Set Constants

#PLATFORM=tpa
PLATFORM=$1
#ENVIRONMENT=dev
ENVIRONMENT=$2
#APPLICATION=tpa-api
APPLICATION=$3
#ARN=485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api
ARN=$4

# Get deployment file path
FILE=./$PLATFORM-$ENVIRONMENT/$APPLICATION/$ENVIRONMENT-$APPLICATION-deployment.yaml

# Login to AWS
$(aws ecr get-login --no-include-email --region us-west-1) &&

# TODO: Check if this version already exists in ECR and throw graceful error

# Increment minor version
sh increment-minor.sh $1 $2 $3 $4 &&

# Load version
VERSION=$(jq --arg env "$PLATFORM-$ENVIRONMENT" --arg app "$APPLICATION" '.[$env] | .[$app]' versions.json) &&
VERSION=$(echo $VERSION | tr -d '"') &&

echo Deploying version: $VERSION &&

# Update Version in deployment configuration
sed -i.bak "s#${ARN}:.*#${ARN}:${VERSION}#" "${FILE}" &&

# Clean up all unused docker images
docker image prune -a -f &&

# Create container image - TODO: Update path to dockerfile
docker build -t ${APPLICATION} ../repositories/$APPLICATION &&

# Tag and upload new version of the image to AWS-ECR
docker tag ${APPLICATION}:latest ${ARN}:latest &&
docker push ${ARN}:latest &&
docker tag ${APPLICATION}:latest ${ARN}:${VERSION} &&
docker push ${ARN}:${VERSION} &&

# Update deployment
kubectl apply -f "${FILE}" &&

echo Deployment complete.
