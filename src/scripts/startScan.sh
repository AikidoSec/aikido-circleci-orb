#!/bin/bash
# https://circleci.com/docs/orbs-best-practices/#accepting-parameters-as-strings-or-environment-variables
echo "${GIT_BRANCH} ${GIT_URL} ${GIT_COMMIT_SHA}"
