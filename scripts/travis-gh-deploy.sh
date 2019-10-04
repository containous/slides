#!/bin/bash

set -eu

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DOCS_DIR="${CURRENT_DIR}/../docs"
DEPLOY_BRANCH="gh-pages"
DIST_DIR="${CURRENT_DIR}/../dist"

echo "== Using git reference '${TRAVIS_BRANCH}'"

rm -rf "${DOCS_DIR}"
git config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch --unshallow origin "${DEPLOY_BRANCH}" 2>/dev/null  || git fetch origin
git worktree add -b "${DEPLOY_BRANCH}" "${DOCS_DIR}" origin/"${DEPLOY_BRANCH}" 2>/dev/null || git worktree add --force "${DOCS_DIR}" origin/"${DEPLOY_BRANCH}" 2>/dev/null

# If a tag triggered the build, then TRAVIS_BRANCH == TRAVIS_TAG
DEPLOY_DIR="${DOCS_DIR}/${TRAVIS_BRANCH}"
mkdir -p "${DEPLOY_DIR}"

# TODO: update index.html

# Generate QRCode to ./dist/images/qrcode.png and overwrite the default one
make qrcode

### Factorize resources already existing
# Factorization is done on filename: if you don't name your file correctly it will be overriden
# (reason: if any image optim happens on branches, then the same image will be duplicated for nothing)
for resource_dir in videos images fonts
do
    for resource in "${DIST_DIR}/${resource_dir}"/*
    do
        resource_file="$(basename "${resource}")"
        if [ -f "${DOCS_DIR}/${resource_dir}/${resource_file}" ]
        then
            pushd "${DIST_DIR}/${resource_dir}"
            rm -f "${resource_file}"
            ln -s "${DOCS_DIR}/${resource_dir}/${resource_file}" "${resource_file}"
            popd
        fi
    done
done


rsync -av "${DIST_DIR}" "${DEPLOY_DIR}"
