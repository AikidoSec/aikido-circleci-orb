#!/bin/bash

CMD="aikido-api-client scan ${REPO_ID} ${BASE_COMMIT_SHA} ${HEAD_COMMIT_SHA} <<parameters.head_commit_sha>> --apikey ${AIKIDO_API_KEY}"

eval "$CMD"