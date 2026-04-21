set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

git config --global user.email "mpk@process-factory.dk"
git config --global user.name "Marc Pekilidi"

cp ${SCRIPT_DIR}/maven/* ~/.m2/

PF_BASE_DIR="${BASE_DIR}/pf"
PR_DIR="${PF_BASE_DIR}/pr"
WIP_DIR="${PF_BASE_DIR}/wip"
COP_DIR="${PF_BASE_DIR}/connectorplus"
OL_DIR="${PF_BASE_DIR}/onelogic"
LIB_DIR="${PF_BASE_DIR}/libraries"
INF_DIR="${PF_BASE_DIR}/infrastructure"
INT_DIR="${PF_BASE_DIR}/integration"

mkdir -p ${PR_DIR}
mkdir -p ${WIP_DIR}
mkdir -p ${COP_DIR}
mkdir -p ${OL_DIR}
mkdir -p ${LIB_DIR}
mkdir -p ${INF_DIR}
mkdir -p ${INT_DIR}

pushd ${COP_DIR}

[[ -d "${COP_DIR}/connectorplus-core" ]] || git clone git@bitbucket.org:profac/connectorplus-core.git
[[ -d "${COP_DIR}/claim-history" ]] || git clone git@bitbucket.org:profac/claim-history.git
[[ -d "${COP_DIR}/claim-history-ui" ]] || git clone git@bitbucket.org:profac/claim-history-ui.git
[[ -d "${COP_DIR}/cancellation" ]] || git clone git@bitbucket.org:profac/cancellation.git
[[ -d "${COP_DIR}/cancellation-ui" ]] || git clone git@bitbucket.org:profac/cancellation-ui.git
[[ -d "${COP_DIR}/tl-attest" ]] || git clone git@bitbucket.org:profac/tl-attest.git

