#!/bin/bash

SUDO=""
if [ "$UID" -ne 0 ] && [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

echo "Installing Aikido CI API client..."
echo

$SUDO npm install -g @aikidosec/ci-api-client

echo "Verifying parameters..."
echo

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
echo

BASE_COMMIT_ID=$(git merge-base origin/"$BASE_BRANCH" "$CIRCLE_SHA1")

if [[ "$DEBUG" == 1 ]]; then
    echo "comparing $BASE_COMMIT_ID vs $CIRCLE_SHA1"
    echo
fi

AIKIDO_CMD="$SUDO aikido-api-client scan $AIKIDO_REPOSITORY_ID $BASE_COMMIT_ID $CIRCLE_SHA1 $CIRCLE_BRANCH --apikey $AIKIDO_API_KEY"

# Additional configuration options

if [[ "$FAIL_ON_DEPENDENCY_SCAN" == 0 ]]; then
    AIKIDO_CMD="$AIKIDO_CMD --no-fail-on-dependency-scan"
fi

if [[ "$FAIL_ON_SAST_SCAN" == 1 ]]; then
    AIKIDO_CMD="$AIKIDO_CMD --fail-on-sast-scan"
fi

if [[ "$FAIL_ON_IAC_SCAN" == 1 ]]; then
    AIKIDO_CMD="$AIKIDO_CMD --fail-on-iac-scan"
fi

AIKIDO_CMD="$AIKIDO_CMD --minimum-severity-level $MINIMUM_SEVERITY"

if [ -n "$CIRCLE_PULL_REQUEST" ]; then
    AIKIDO_CMD="$AIKIDO_CMD --pull-request-url $CIRCLE_PULL_REQUEST"
fi

if [[ "$DEBUG" == 1 ]]; then
    AIKIDO_CMD="$AIKIDO_CMD --debug"
fi

# start scan
echo "$AIKIDO_CMD"
echo

$AIKIDO_CMD
