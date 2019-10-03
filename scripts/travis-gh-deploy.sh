#!/bin/bash

set -eux

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DOCS_DIR="${CURRENT_DIR}/../docs"
DEPLOY_BRANCH="gh-pages"
echo "== Using git ref. ${TRAVIS_BRANCH}"

# Rebuild the docs directory which will be uploaded to gh-pages
rm -rf "${DOCS_DIR}"
git config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*;
git fetch --unshallow origin gh-pages;
git worktree add -b gh-pages "${DOCS_DIR}" origin/gh-pages;
ls -ltr "${DOCS_DIR}/"
exit 1
# time git fetch --unshallow origin "${DEPLOY_BRANCH}"
# time git worktree add --force "${DOCS_DIR}" "origin/${DEPLOY_BRANCH}"

# If a tag triggered the build, then TRAVIS_BRANCH == TRAVIS_TAG
DEPLOY_DIR="${DOCS_DIR}/${TRAVIS_BRANCH}"
mkdir -p "${DEPLOY_DIR}"

# TODO: update index.html

# Generate QRCode and overwrite the default one
make qrcode

time rsync -av ./dist/ "${DEPLOY_DIR}"
