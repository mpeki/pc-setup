#!/usr/bin/env bash
set -euo pipefail

echo "Updating APT package index..."
sudo apt update

echo "Upgrading APT packages (safe)..."
sudo apt upgrade -y

echo "Upgrading APT packages (allow dependency changes)..."
sudo apt full-upgrade -y

echo "Cleaning up APT..."
sudo apt autoremove -y
sudo apt autoclean -y

echo
echo "Updating snaps..."
if command -v snap >/dev/null 2>&1; then
  sudo snap refresh
else
  echo "snap not installed. Skipping."
fi

echo
echo "Updating flatpaks..."
if command -v flatpak >/dev/null 2>&1; then
  flatpak update -y
else
  echo "flatpak not installed. Skipping."
fi

echo
echo "Checking for new Ubuntu release..."
if sudo do-release-upgrade -c >/tmp/ubuntu-release-check.log 2>&1; then
  echo "A new Ubuntu release is available."
  grep -i "new release" /tmp/ubuntu-release-check.log || cat /tmp/ubuntu-release-check.log
  echo "Run: sudo do-release-upgrade"
else
  echo "No new Ubuntu release available."
fi

echo
echo "Checking for Homebrew (Linuxbrew)..."
if command -v brew >/dev/null 2>&1; then
  brew update
  brew upgrade
  brew cleanup
else
  echo "Homebrew not installed. Skipping."
fi

# Keep Ubuntu Software from showing stale updates
pkill -f snap-store 2>/dev/null || true
rm -rf ~/.cache/snap-store/* ~/.cache/gnome-software/* 2>/dev/null || true
