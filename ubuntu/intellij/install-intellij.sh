#!/usr/bin/env bash
set -euo pipefail

TOOLBOX_VERSION="3.4.0.77112"
export IDEA_VERSION="2025.3"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "${SETUP_DIR}/.intellij-installed" ]]; then
	echo "IntelliJ already installed, skipping this step."
else
	sudo apt install libfuse2

  [[ ! -f "${SETUP_DIR}/jetbrains-toolbox.tar.gz" ]] && \
		curl -fL -o "${SETUP_DIR}/jetbrains-toolbox.tar.gz" "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-${TOOLBOX_VERSION}.tar.gz"
	
	[[ -d "${SETUP_DIR}/jetbrains-toolbox" ]] && rm -rf "${SETUP_DIR}/jetbrains-toolbox"
	tar -xvf "${SETUP_DIR}/jetbrains-toolbox.tar.gz" -C "${SETUP_DIR}"
	mv "${SETUP_DIR}/jetbrains-toolbox-${TOOLBOX_VERSION}" "${SETUP_DIR}/jetbrains-toolbox"

	nohup "${SETUP_DIR}/jetbrains-toolbox/bin/jetbrains-toolbox" >/dev/null 2>&1 &
	TOOLBOX_PID=$!
	echo "Started Toolbox with PID $TOOLBOX_PID"
	read -r -p "Install IntelliJ using the toolbox, then press Enter to continue..."
    "${SCRIPT_DIR}/sync-settings.sh"
	touch "${SETUP_DIR}/.intellij-installed"
fi

echo "fetching changed intellij settings..."
TEMP_CONFIG_DIR="${SETUP_DIR}/idea-settings/IntelliJIdea${IDEA_VERSION}_config"
[[ ! -d ${TEMP_CONFIG_DIR} ]] && mkdir -p ${TEMP_CONFIG_DIR}

"${SCRIPT_DIR}/../sync-files.sh" ${HOME}/.config/JetBrains/IntelliJIdea${IDEA_VERSION}/ "${TEMP_CONFIG_DIR}" intellij

#TODO create a gpg file and copy it back to the project