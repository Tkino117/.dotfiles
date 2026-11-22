#!/usr/bin/env bash
# この dotfiles を使うのに必要なツールをまとめてインストールする（Linux(apt) / macOS）
# git / vim / ghostty は対象外
set -euo pipefail

OS="$(uname -s)"

has() { command -v "$1" >/dev/null 2>&1; }

# ============================================================
# zsh（ログインシェルにする）
# ============================================================
install_zsh() {
    if [[ "$OS" == Linux ]]; then
        echo "[zsh]"
        # Homebrew のビルドに必要なものもここで入れる
        sudo apt-get update
        sudo apt-get install -y zsh build-essential procps curl file git fontconfig xz-utils
    fi
    # macOS は標準で zsh が入っている
    if [[ "$(basename "${SHELL:-}")" != zsh ]]; then
        # パスワード未設定のユーザー（クラウド VM など）でも通るよう sudo で実行
        sudo chsh -s "$(command -v zsh)" "$USER"
    fi
}

# ============================================================
# Homebrew（Linux では Linuxbrew）
# ============================================================
install_brew() {
    echo "[Homebrew]"
    if ! has brew; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if [[ "$OS" == Linux ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

# ============================================================
# brew で入れるツール
# ============================================================
FORMULAE=(
    stow        # dotfiles のリンク
    sheldon     # zsh プラグイン管理
    starship    # プロンプト
    fzf         # Ctrl-R / Ctrl-T / Alt-C
    zoxide      # z / zi、yazi の zoxide 連携
    tmux
    yazi
)

# yazi のプレビュー・検索用
YAZI_EXTRAS=(
    ffmpeg sevenzip jq poppler fd ripgrep imagemagick
)

install_formulae() {
    echo "[brew formulae]"
    brew install "${FORMULAE[@]}" "${YAZI_EXTRAS[@]}"
}

# ============================================================
# Nerd Font（JetBrains Mono）
# ============================================================
install_font() {
    echo "[Nerd Font]"
    if [[ "$OS" == Darwin ]]; then
        brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1 \
            || brew install --cask font-jetbrains-mono-nerd-font
        return
    fi
    local dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
    if [[ -d "$dir" ]]; then
        echo "  already installed"
        return
    fi
    mkdir -p "$dir"
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
        | tar -xJ -C "$dir"
    fc-cache -f "$dir"
}

main() {
    install_zsh
    install_brew
    install_formulae
    install_font

    # zsh プラグインの取得（plugins.toml が stow 済みのとき）
    if [[ -f "$HOME/.config/sheldon/plugins.toml" ]]; then
        sheldon lock
    else
        echo "sync.sh を実行してから 'sheldon lock' を実行してください"
    fi

    echo "Done. 'exec zsh' で設定を読み込み直してください。"
}

main "$@"
