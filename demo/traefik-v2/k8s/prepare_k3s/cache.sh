#!/bin/bash

set -eu -o pipefail

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"

echo "== Loading Image Cache"
while IFS= read -r IMAGE
do
  docker pull "${IMAGE}" &
done < <(cat "${CURRENT_DIR}/images_list")
wait

echo "== Cache pulled successfully"
