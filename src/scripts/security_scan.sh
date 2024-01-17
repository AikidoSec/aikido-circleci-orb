#!/bin/bash

echo -n "Installing Aikido CI API client..."

npm install -g @aikidosec/ci-api-client

echo "Verifying parameters..."

if [ -z "$AIKIDO_API_KEY" ]; then
    echo "AIKIDO_API_KEY not set. Please provide one as an environment variable and try again."
    exit 1
fi

if [ -z "$AIKIDO_REPOSITORY_ID" ]; then
    echo "AIKIDO_REPOSITORY_ID not set. Please provide an environment variable one and try again."
    exit 1
fi

if [ -z "$BASE_BRANCH" ]; then
    echo "base_branch not set. Please provide one and try again."
    exit 1
fi

echo "Finding base commit sha"

BASE_COMMIT_ID=$(git merge-base origin/"$BASE_BRANCH" "$CIRCLE_SHA1")

AIKIDO_CMD="aikido-api-client scan $AIKIDO_REPOSITORY_ID $BASE_COMMIT_ID $CIRCLE_SHA1 $CIRCLE_BRANCH --apikey $AIKIDO_API_KEY"

# Additional configuration options

if [[ "$FAIL_ON_DEPENDENCY_SCAN" == 1 ]]; then
    AIKIDO_CMD="$AIKIDO_CMD --no-fail-on-dependency-scan"
fi

if [[ "$FAIL_ON_SAST_SCAN" == 1 ]]; then
    AIKIDO_CMD="$AIKIDO_CMD --fail-on-sast-scan"
fi

if [[ "$FAIL_ON_IAC_SCAN" == 1 ]]; then
    AIKIDO_CMD="$AIKIDO_CMD --fail-on-iac-scan"
fi

AIKIDO_CMD="$AIKIDO_CMD --minimum-severity-level $MINIMUM_SEVERITY"

if [ -z "$CIRCLE_PULL_REQUEST" ]; then
    AIKIDO_CMD="$AIKIDO_CMD --pull-request-url $CIRCLE_PULL_REQUEST"
fi

# start scan
echo "$AIKIDO_CMD"

$AIKIDO_CMD
