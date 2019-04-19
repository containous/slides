#!/bin/bash

set -e -o pipefail

# Fetch arguments
EXTERNAL_HOSTNAME="${1}"
BACKEND_IP="${2}"

# Verify Arguments
[ -n "${EXTERNAL_HOSTNAME}" ] || (
  echo "== ERROR: No external hostname provided (argument #1)."
  exit 1
)
[ -n "${BACKEND_IP}" ] || (
  echo "== ERROR: No backend ip hostname provided (argument #2)."
  exit 1
)
if ! [[ "${BACKEND_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "== ERROR: The backend ip ${IP} is not valid."
  exit 1
fi

set -u

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
TEMPLATE_PATH="${CURRENT_DIR}/lab-template.toml"
[ -f "${TEMPLATE_PATH}" ] || (
  echo "== ERROR: Cannot find the TOMl template at ${TEMPLATE_PATH}."
  exit 1
)
TRAEFIK_PROVIDER_FILENAME="${EXTERNAL_HOSTNAME}.toml"
TRAEFIK_PROVIDER_FILE_PATH="${CURRENT_DIR}/traefik/${TRAEFIK_PROVIDER_FILENAME}"

# Template rendering
sed "s/PUBLIC_HOSTNAME/${EXTERNAL_HOSTNAME}/g" "${TEMPLATE_PATH}" \
  | sed "s/PRIVATE_HOSTNAME/${BACKEND_IP}/g"\
  | sed "s/LAB_NAME/${EXTERNAL_HOSTNAME//./-}/g" \
  > "${TRAEFIK_PROVIDER_FILE_PATH}"

echo "== INFO: Update of the entry \"${EXTERNAL_HOSTNAME} -> ${BACKEND_IP}\" done successfully."
exit 0
