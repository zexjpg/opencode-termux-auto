#!/usr/bin/env bash
set -euo pipefail

log() { printf '[opencode-termux] %s\n' "$*"; }
fail() { printf '[opencode-termux] ERROR: %s\n' "$*" >&2; exit 1; }
ensure_dir() { mkdir -p "$1"; }