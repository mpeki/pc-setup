#!/usr/bin/env bash
set -ue

export BASE_DIR="${HOME}/work"
export SETUP_DIR="${BASE_DIR}/ps-setup"
export SCRIPTS_BIN="${BASE_DIR}/scripts/bin"


detect_os() {
  local uname_s
  uname_s="$(uname -s)"
  printf "Checking operating system..."
  case "$uname_s" in
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        PLATFORM="wsl"
        OS="windows"
        DISTRO="wsl"
      elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        PLATFORM="linux"
        OS="linux"
        DISTRO="${ID:-unknown}"
      else
        PLATFORM="linux"
        OS="linux"
        DISTRO="unknown"
      fi
      ;;
    CYGWIN*)
      PLATFORM="windows"
      OS="windows"
      DISTRO="cygwin"
      ;;
    MINGW*|MSYS*)
      PLATFORM="windows"
      OS="windows"
      DISTRO="mingw"
      ;;
    Darwin)
      PLATFORM="macos"
      OS="macos"
      DISTRO="macos"
      ;;
    *)
      PLATFORM="unknown"
      OS="unknown"
      DISTRO="unknown"
      ;;
  esac
  printf " looks like we are running %s (%s)\n" "${OS}" "${DISTRO}"
  export PLATFORM OS DISTRO
}

detect_os

if [[ ${OS} == "linux" ]]; then

	if [[ ! -d  "${SETUP_DIR}" ]]; then
		echo "Creating setup dir: ${SETUP_DIR}..."
	  	mkdir -p ${SETUP_DIR}
	fi

	if [[ ! -d "${SCRIPTS_BIN}" ]]; then
		echo "Creating scripts bin dir: ${SCRIPTS_BIN}..."
	  	mkdir -p ${SCRIPTS_BIN}
	fi

	


	if [[ ${DISTRO} == "ubuntu" ]]; then
		./ubuntu/ubuntu-setup.sh
	fi
fi

