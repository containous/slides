#!/bin/bash

set -eu -o pipefail

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"

echo "== Preparing Docker Images Cache (build or pull)"
while IFS= read -r LINE
do  
  echo "==== $LINE"
  type="$(echo "${LINE}" | cut -d'|' -f1)"
  image_name="$(echo "${LINE}" | cut -d'|' -f2)"
  if [ "${type}" == "pull" ]
  then
    # Pull images in parallel: it's faster
    docker pull "${image_name}" &
  elif [ "${type}" == "build" ]
  then
    # Build custom local image
    image_context="$(echo "${LINE}" | cut -d'|' -f3)"
    docker build -t "${image_name}" "${image_context}" &
  fi
done < <(cat "${CURRENT_DIR}/images_list")
# wait
echo "== Cache pulled successfully"
