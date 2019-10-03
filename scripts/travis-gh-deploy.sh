#!/bin/bash

set -eux

ZIP_FILE=gh-pages.zip
ARCHIVE_URL="${REPOSITORY_BASE_URL}/archive/${ZIP_FILE}"
CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DOCS_DIR="${CURRENT_DIR}/../docs"

# Rebuild the docs directory which will be uploaded to gh-pages
rm -rf "${DOCS_DIR}"
if curl -sSLI --fail "${ARCHIVE_URL}"
then
    time curl -sSLO "${ARCHIVE_URL}"
    unzip -o "./${ZIP_FILE}"
    mv ./"$(basename "${REPOSITORY_BASE_URL}")"-${ZIP_FILE%%.*} "${DOCS_DIR}" # No ".zip" at the end
    rm -f "./${ZIP_FILE}"
else
    echo "== No gh-pages found, I assume this is the first time."
    mkdir -p "${DOCS_DIR}"
fi

# If a tag triggered the build, then TRAVIS_BRANCH == TRAVIS_TAG
echo "== Using git ref. ${TRAVIS_BRANCH}"
DEPLOY_DIR="${DOCS_DIR}/${TRAVIS_BRANCH}"
mkdir -p "${DEPLOY_DIR}"

# Generate QRCode and overwrite the default one
make qrcode

time rsync -av ./dist/ "${DEPLOY_DIR}"
