#!/bin/bash

set -eux

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DOCS_DIR="${CURRENT_DIR}/../docs"
DEPLOY_BRANCH="gh-pages"

echo "== Using git ref. ${TRAVIS_BRANCH}"

rm -rf "${DOCS_DIR}"
git config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*;
git fetch --unshallow origin "${DEPLOY_BRANCH}";
git worktree add -b "${DEPLOY_BRANCH}" "${DOCS_DIR}" origin/"${DEPLOY_BRANCH}";

# If a tag triggered the build, then TRAVIS_BRANCH == TRAVIS_TAG
DEPLOY_DIR="${DOCS_DIR}/${TRAVIS_BRANCH}"
mkdir -p "${DEPLOY_DIR}"

# TODO: update index.html

# Generate QRCode and overwrite the default one
make qrcode

time rsync -av ./dist/ "${DEPLOY_DIR}"
