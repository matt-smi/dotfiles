#!/usr/bin/env bash
# Stows dotfiles into $HOME using GNU Stow.
#
#   dots/   shared across every machine
#   linux/  Linux-only (rofi, waybar, hypr, ...)
#   macos/  macOS-only
#
# Always stows dots/, plus the package matching this OS if it exists.
# Usage: ./setup.sh [--adopt]
# Requires GNU Stow. Run from anywhere; it cd's to its own directory.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if ! command -v stow >/dev/null 2>&1; then
  echo "error: stow is not installed. Please install stow first." >&2
  exit 1
fi

if [[ $# -gt 0 && "$1" != "--adopt" ]]; then
  echo "usage: $0 [--adopt]" >&2
  exit 1
fi

if [[ ! -d dots ]]; then
  echo "error: no 'dots' directory found next to setup.sh" >&2
  exit 1
fi

case "$(uname -s)" in
Darwin) os_pkg="macos" ;;
Linux) os_pkg="linux" ;;
*) os_pkg="" ;;
esac

packages=(dots)
if [[ -n "$os_pkg" && -d "$os_pkg" ]]; then
  packages+=("$os_pkg")
fi

# -R restows, so the script is safe to re-run.
# -t "$HOME" targets your home dir even if this repo isn't in ~/dotfiles.
stow_flags=(-R -v -t "$HOME")

if [[ "${1:-}" == "--adopt" ]]; then
  # Existing real files in $HOME are MOVED into the package (overwriting the
  # repo's copy), then replaced with symlinks. Review with 'git diff'
  # afterwards; 'git restore .' keeps the repo's versions instead.
  stow_flags+=(--adopt)
  echo "Adopting existing files into the repo (review with 'git diff')"
fi

echo "Stowing: ${packages[*]} -> $HOME"
stow "${stow_flags[@]}" "${packages[@]}"

echo "Done."
