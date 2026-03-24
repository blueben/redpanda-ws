#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  shift
  if "$@" &>/dev/null; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc"
    ((FAIL++))
  fi
}

echo "==> redpanda-ws verification"
echo ""

echo "--- Core tools ---"
check "git installed"      command -v git
check "curl installed"     command -v curl
check "ripgrep installed"  command -v rg
check "fd installed"       command -v fd
check "jq installed"       command -v jq
check "fzf installed"      command -v fzf
check "tmux installed"     command -v tmux
check "zsh installed"      command -v zsh

echo ""
echo "--- Dev tools ---"
check "node installed"     command -v node
check "python installed"   command -v python3
check "go installed"       command -v go
check "make installed"     command -v make
check "cmake installed"    command -v cmake
check "shellcheck installed" command -v shellcheck

echo ""
echo "--- Managed tools ---"
check "chezmoi installed"  command -v chezmoi
check "atuin installed"    command -v atuin

echo ""
echo "--- Services ---"
OS="$(uname -s)"
if [ "$OS" = "Linux" ]; then
  check "atuin sync timer active" systemctl --user is-active atuin-sync.timer
elif [ "$OS" = "Darwin" ]; then
  check "atuin sync agent loaded" launchctl list com.atuin.sync
fi

echo ""
echo "--- Sysctl ---"
if [ "$OS" = "Linux" ]; then
  check "inotify watches tuned" test "$(sysctl -n fs.inotify.max_user_watches)" -ge 524288
elif [ "$OS" = "Darwin" ]; then
  check "maxfiles tuned" test "$(sysctl -n kern.maxfiles)" -ge 65536
fi

echo ""
echo "--- Chezmoi ---"
if command -v chezmoi &>/dev/null; then
  check "chezmoi repo initialized" test -d "$HOME/.local/share/chezmoi"
  CHEZMOI_STATUS="$(chezmoi status 2>/dev/null || true)"
  if [ -z "$CHEZMOI_STATUS" ]; then
    echo "  [PASS] chezmoi fully applied (no drift)"
    ((PASS++))
  else
    echo "  [WARN] chezmoi has pending changes"
  fi
fi

echo ""
echo "==> Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
