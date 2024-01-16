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

if [ -z "$BASE_COMMIT_SHA" ]; then
    echo "base_commit_sha not set. Please provide one and try again."
    exit 1
fi

if [ -z "$HEAD_COMMIT_SHA" ]; then
    echo "head_commit_sha not set. Please provide one and try again."
    exit 1
fi

echo "Starting Aikido CI scan..."

aikido-api-client scan "$AIKIDO_REPOSITORY_ID" "$BASE_COMMIT_SHA" "$HEAD_COMMIT_SHA" --apikey "$AIKIDO_API_KEY"
