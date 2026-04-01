#!/usr/bin/env bash
set -euo pipefail

cp ./ubuntu/intellij/settings/idea${IDEA_VERSION}.config.tar.gz.gpg ${SETUP_DIR}
pushd ${SETUP_DIR}

gpg -d idea${IDEA_VERSION}.config.tar.gz.gpg | tar -xzf -

read -r -p "Make sure IntelliJ is not running, then press Enter to continue..."

sudo rsync -a IntelliJIdea${IDEA_VERSION}_config/ ${HOME}/.config/JetBrains/IntelliJIdea${IDEA_VERSION}/



