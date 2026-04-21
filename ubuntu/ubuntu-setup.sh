#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "${SETUP_DIR}/.base-tools-installed" ]]; then
	echo "Tools already installed, skipping this step."
else

	echo "Installing Ubuntu tools..."

	# Add CopyQ PPA if missing
	if ! grep -Rqs "^deb .*hluk/copyq" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
	  sudo add-apt-repository -y ppa:hluk/copyq
	fi

	sudo apt-get update
	sudo apt-get install -y curl copyq git fzf

	# Install Chrome
	CHROME_DEB="/tmp/google-chrome-stable_current_amd64.deb"

	if ! dpkg -s google-chrome-stable >/dev/null 2>&1; then
	  wget -O "$CHROME_DEB" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	  sudo apt-get install -y "$CHROME_DEB"
	fi


	curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "${SCRIPTS_BIN}/git-completion.bash"
	curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o "${SCRIPTS_BIN}/git-prompt.sh"

  if [[ -d /home/linuxbrew/.linuxbrew ]]; then
    sudo chown -R "${USER}" /home/linuxbrew/.linuxbrew
  fi

  # Install SdkMan
  ensure_sdkman

  sdk install java 21.0.10-tem
  sdk install maven 3.9.14

  touch "${SETUP_DIR}/.base-tools-installed"

fi

"${SCRIPT_DIR}/sync-files.sh" "${SCRIPT_DIR}/profile/files" "${HOME}" profile
"${SCRIPT_DIR}/sync-files.sh" "${SCRIPT_DIR}/scripts" "${SCRIPTS_BIN}" scripts

# Set dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# fetch and set background image
curl -fsSL https://www.nasa.gov/wp-content/uploads/2026/04/art002e009288orig-1.jpg -o /usr/share/backgrounds/artemis2-earth-rise.jpg
[[ -f /usr/share/backgrounds/artemis2-earth-rise.jpg ]] && gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/artemis2-earth-rise.jpg"

ensure_sdkman() {
  if [[ -d "$HOME/.sdkman" && -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    printf 'SDKMAN is already installed.\n'
    return 0
  fi

  printf 'SDKMAN is not installed. Installing...\n'

  if ! command -v curl >/dev/null 2>&1; then
    printf 'Error: curl is not installed.\n' >&2
    return 1
  fi

  if ! curl -s "https://get.sdkman.io" | bash; then
    printf 'Error: SDKMAN installation failed.\n' >&2
    return 1
  fi

  # Load SDKMAN into the current shell session
  if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    # shellcheck disable=SC1090
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    printf 'SDKMAN installed successfully.\n'
  else
    printf 'Error: SDKMAN install completed, but init script was not found.\n' >&2
    return 1
  fi
}