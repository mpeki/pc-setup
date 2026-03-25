#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${1:?Usage: $0 <source-directory> <target-directory> [backup_name]}"
TARGET_DIR="${2:?Usage: $0 <source-directory> <target-directory> [backup_name]}"
BACKUP_NAME="${3:-sync}"
SETUP_DIR="${SETUP_DIR:?SETUP_DIR is not set}"

SOURCE_DIR="$(realpath "$SOURCE_DIR")"
TARGET_DIR="$(realpath "$TARGET_DIR")"
BACKUP_ROOT="$(realpath "$SETUP_DIR")/backup"

ALLOWED_TARGET_BASE="${HOME}"

case "$TARGET_DIR" in
  "$ALLOWED_TARGET_BASE"|"$ALLOWED_TARGET_BASE"/*) ;;
  *)
    printf 'Error: target must be under %s: %s\n' "$ALLOWED_TARGET_BASE" "$TARGET_DIR" >&2
    exit 1
    ;;
esac

if [[ ! -d "$SOURCE_DIR" ]]; then
  printf 'Error: source directory does not exist: %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  printf 'Error: target directory does not exist: %s\n' "$TARGET_DIR" >&2
  exit 1
fi

if [[ "$SOURCE_DIR" == "$TARGET_DIR" ]]; then
  printf 'Error: source and target are the same: %s\n' "$SOURCE_DIR" >&2
  exit 1
fi


timestamp="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${BACKUP_NAME}_${timestamp}"

mkdir -p "$BACKUP_DIR"

rsync -avu --backup --backup-dir="$BACKUP_DIR" "$SOURCE_DIR"/ "$TARGET_DIR"/

rmdir "$BACKUP_DIR" 2>/dev/null || true