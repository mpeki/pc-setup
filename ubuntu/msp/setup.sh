#!/usr/bin/env bash
set -euo pipefail

MSP_DIR="${BASE_DIR}/private"

[[ -d "${MSP_DIR}" ]] || mkdir "${MSP_DIR}"

pushd ${MSP_DIR}

[[ -d "${MSP_DIR}/pc-setup" ]] || git clone git@github.com:mpeki/pc-setup.git
[[ -d "${MSP_DIR}/profac-test-plugin" ]] || git clone git@github.com:mpk-pf/profac-test-plugin.git
[[ -d "${MSP_DIR}/cpl-dev" ]] || git clone git@bitbucket.org:profac/cpl-dev.git

if command -v pass-cli >/dev/null 2>&1; then
  curl -fsSL https://proton.me/download/pass-cli/install.sh
fi