#!/bin/bash

set -eu -o pipefail

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"

CLUSTER_NAME="$(grep "NAME=" "${CURRENT_DIR}/run.sh" | cut -d'"' -f2)"

k3d delete --name="${CLUSTER_NAME}"
