#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 設定ファイルを同期
source "$SCRIPT_DIR/dotfiles/sync.sh"

# ログインシェルを zsh に変更
sudo apt-get install -y zsh
chsh -s "$(command -v zsh)"
