#!/bin/sh

# This is a convenience script to match all applications versions to the specific values located in versions.json
# NOTE: Scripts must be run from the project's root directory (up one folder from here)

# Run command for each application in each environment (Refactor this)
sh scripts/deploy.sh tpa dev tpa-api 485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api &&
sh scripts/deploy.sh tpa qa tpa-api 485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api &&
sh scripts/deploy.sh tpa staging tpa-api 485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api &&

# sh scripts/deploy.sh tpa dev tpa-web 485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-web &&
# sh scripts/deploy.sh tpa qa tpa-web 485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-web &&
# sh scripts/deploy.sh tpa staging tpa-web 485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-web