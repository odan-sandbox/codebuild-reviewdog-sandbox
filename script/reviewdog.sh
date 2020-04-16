#!/bin/bash

# Setup
API_ENDPOINT=https://api.github.com
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

CI_REPO_NAME=$(basename $CODEBUILD_SOURCE_REPO_URL)
CI_REPO_OWNER=$(basename $(dirname $CODEBUILD_SOURCE_REPO_URL))
CI_COMMIT=$CODEBUILD_RESOLVED_SOURCE_VERSION

CI_PULL_REQUEST=$(curl -H "$AUTH_HEADER" \
  "$API_ENDPOINT/repos/$CI_REPO_OWNER/$CI_REPO_NAME/pulls?head=$CI_REPO_OWNER:$CODEBUILD_WEBHOOK_HEAD_REF" \
  | jq ".[].number")

REVIEWDOG_GITHUB_API_TOKEN=$GITHUB_TOKEN

# Download
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s
chmod +x ./bin/reviewdog

./bin/reviewdog -reporter=github-pr-review