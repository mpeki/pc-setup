#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${1:?Usage: $0 <source-directory>}"
SETUP_DIR="${SETUP_DIR:?SETUP_DIR is not set}"
BACKUP_DIR="${SETUP_DIR}/backup"

if [[ ! -d "$SOURCE_DIR" ]]; then
  printf 'Error: source directory does not exist: %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

timestamp="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${SETUP_DIR}/backup/$timestamp"

mkdir -p "$BACKUP_DIR"

rsync -avc --backup --backup-dir="${BACKUP_DIR}" "${SOURCE_DIR}"/ "${HOME}"/

rmdir "$BACKUP_DIR" 2>/dev/null || true