#!/bin/bash

echo -n "Verifying parameters..."

if [ -z "$AIKIDO_API_KEY" ]; then
    echo "aikido_api_key not set. Please provide one and try again."
    exit 1
fi

if [ -z "$REPO_ID" ]; then
    echo "repository_id not set. Please provide one and try again."
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

echo -n "Starting Aikido CI scan..."

aikido-api-client scan "$REPO_ID" "$BASE_COMMIT_SHA $HEAD_COMMIT_SHA" --apikey "$AIKIDO_API_KEY"
