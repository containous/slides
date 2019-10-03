#!/bin/bash

set -eux

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DOCS_DIR="${CURRENT_DIR}/../docs"
DEPLOY_BRANCH="gh-pages"
echo "== Using git ref. ${TRAVIS_BRANCH}"

# Rebuild the docs directory which will be uploaded to gh-pages
rm -rf "${DOCS_DIR}"
if git branch --remotes | grep "origin/${DEPLOY_BRANCH}"
then
    time git worktree add --force "${DOCS_DIR}" "${DEPLOY_BRANCH}"
else
    echo "== No gh-pages found, I assume this is the first time."
    mkdir -p "${DOCS_DIR}"
fi

# If a tag triggered the build, then TRAVIS_BRANCH == TRAVIS_TAG
DEPLOY_DIR="${DOCS_DIR}/${TRAVIS_BRANCH}"
mkdir -p "${DEPLOY_DIR}"

# TODO: update index.html

# Generate QRCode and overwrite the default one
make qrcode

time rsync -av ./dist/ "${DEPLOY_DIR}"
