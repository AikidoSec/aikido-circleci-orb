#!/bin/bash

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

if [ -z "$HEAD_COMMIT_SHA" ]; then
    echo "head_commit_sha not set. Please provide one and try again."
    exit 1
fi

echo "Getting base commit id"

BASE_COMMIT_ID=$(git merge-base origin/"$BASE_BRANCH" "$HEAD_COMMIT_SHA")

AIKIDO_CMD="aikido-api-client scan $AIKIDO_REPOSITORY_ID $BASE_COMMIT_ID $HEAD_COMMIT_SHA $CIRCLE_BRANCH --apikey $AIKIDO_API_KEY"

# Additional configuration options

if [ "$FAIL_ON_DEPENDENCY_SCAN" = false ]; then
    AIKIDO_CMD="$AIKIDO_CMD --no-fail-on-dependency-scan"
fi

if [ "$FAIL_ON_SAST_SCAN" = true ]; then
    AIKIDO_CMD="$AIKIDO_CMD --fail-on-sast-scan"
fi

if [ "$FAIL_ON_IAC_SCAN" = true ]; then
    AIKIDO_CMD="$AIKIDO_CMD --fail-on-iac-scan"
fi

AIKIDO_CMD="$AIKIDO_CMD --minimum-severity-level $MINIMUM_SEVERITY"

echo "Starting Aikido CI scan..."

$AIKIDO_CMD
