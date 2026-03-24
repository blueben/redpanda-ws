#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> redpanda-ws bootstrap"

OS="$(uname -s)"

case "$OS" in
  Darwin)
    echo "==> Detected macOS"

    # Ensure Xcode CLT
    if ! xcode-select -p &>/dev/null; then
      echo "==> Installing Xcode Command Line Tools..."
      xcode-select --install
      echo "    Waiting for Xcode CLT install to complete. Re-run this script after."
      exit 1
    fi

    # Ensure Homebrew
    if ! command -v brew &>/dev/null; then
      echo "==> Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "==> Installing ansible and git via Homebrew..."
    brew install ansible git
    ;;

  Linux)
    echo "==> Detected Linux"
    echo "==> Installing ansible, git, and python via pacman..."
    sudo pacman -Sy --noconfirm ansible git python
    ;;

  *)
    echo "ERROR: Unsupported OS: $OS"
    exit 1
    ;;
esac

# Verify we're running from inside the repo
if [ ! -f "$SCRIPT_DIR/site.yml" ]; then
  echo "ERROR: site.yml not found in $SCRIPT_DIR"
  echo "       Please clone the repo first and run bootstrap.sh from inside it."
  exit 1
fi

echo "==> Installing Ansible collections..."
ansible-galaxy collection install -r "$SCRIPT_DIR/requirements.yml"

echo "==> Running playbook..."
ansible-playbook "$SCRIPT_DIR/site.yml" "$@"

echo "==> Bootstrap complete."
