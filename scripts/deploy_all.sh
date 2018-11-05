#!/bin/sh

# This is a convenience script to match all applications versions to the specific values located in versions.json
# NOTE: Scripts must be run from the project's root directory (up one folder from here)

# Run command for each application in each environment (Refactor this)
# sh deployment-scripts/deploy.sh <insert platform name> <insert environment> <insert project name> <insert ecr url>

# Example:
# sh deployment-scripts/deploy.sh tpa dev tpa-api 485490441211.dkr.ecr.us-west-1.amazonaws.com/tpa-api
