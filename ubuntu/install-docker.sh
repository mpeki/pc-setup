#!/usr/bin/env bash
set -euo pipefail

DOCKER_PACKAGES=(
  docker-ce
  docker-ce-cli
  containerd.io
  docker-buildx-plugin
  docker-compose-plugin
)

log() {
  printf '%s\n' "$*"
}

have_command() {
  command -v "$1" >/dev/null 2>&1
}

docker_usable_as_current_user() {
  have_command docker && docker info >/dev/null 2>&1
}

docker_installed() {
  have_command docker
}

ensure_prereqs() {
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
}

ensure_docker_repo() {
  local keyring="/etc/apt/keyrings/docker.asc"
  local repo_file="/etc/apt/sources.list.d/docker.list"
  local arch codename repo_line current_line

  arch="$(dpkg --print-architecture)"
  codename="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"
  repo_line="deb [arch=${arch} signed-by=${keyring}] https://download.docker.com/linux/ubuntu ${codename} stable"

  sudo install -m 0755 -d /etc/apt/keyrings

  if [[ ! -f "$keyring" ]]; then
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "$keyring"
    sudo chmod a+r "$keyring"
  fi

  current_line=""
  if [[ -f "$repo_file" ]]; then
    current_line="$(<"$repo_file")"
  fi

  if [[ "$current_line" != "$repo_line" ]]; then
    printf '%s\n' "$repo_line" | sudo tee "$repo_file" >/dev/null
  fi
}

install_docker_if_missing() {
  if docker_installed; then
    log "Docker is already installed."
    return
  fi

  log "Docker not found. Installing Docker..."
  ensure_prereqs
  ensure_docker_repo
  sudo apt-get update
  sudo apt-get install -y "${DOCKER_PACKAGES[@]}"
}

ensure_services_enabled() {
  sudo systemctl enable --now docker
  sudo systemctl enable --now containerd
}

ensure_docker_group_exists() {
  if ! getent group docker >/dev/null; then
    sudo groupadd docker
  fi
}

ensure_user_in_docker_group() {
  if id -nG "$USER" | grep -qw docker; then
    log "User $USER is already in docker group."
    return
  fi

  sudo usermod -aG docker "$USER"
  log "Added $USER to docker group."
}

main() {
  if docker_usable_as_current_user; then
    log "Docker is already installed and usable by $USER. No changes needed."
    exit 0
  fi

  install_docker_if_missing
  ensure_services_enabled
  ensure_docker_group_exists

  if docker_usable_as_current_user; then
    log "Docker is now usable by $USER."
    exit 0
  fi

  ensure_user_in_docker_group

  if docker_usable_as_current_user; then
    log "Docker is now usable by $USER."
    exit 0
  fi

  log "Docker is installed, but the current shell does not yet have docker-group access."
  log "Log out and back in, or run: newgrp docker"
  log "After that, verify with: docker info"
}

main "$@"