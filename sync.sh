#!/usr/bin/env bash
# dotfiles を stow でホームディレクトリにリンクする
set -euo pipefail

# ===== stow の対象外にするディレクトリ（リポジトリ直下の非パッケージ） =====
IGNORE=(
    .git
    .bak
    .claude
    .vscode
    docker
    ref
)

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME"
BACKUP_DIR="$DOTFILES_DIR/.bak/$(date +%Y%m%d_%H%M%S)"

is_ignored() {
    local name="$1"
    for ig in "${IGNORE[@]}"; do
        [[ "$name" == "$ig" ]] && return 0
    done
    return 1
}

# ===== stow のインストール =====
install_stow() {
    if command -v stow >/dev/null 2>&1; then
        echo "stow is already installed"
        return
    fi
    echo "Installing stow..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v brew >/dev/null 2>&1; then
        brew install stow
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y stow
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm stow
    else
        echo "Error: パッケージマネージャが見つかりません。stow を手動でインストールしてください" >&2
        exit 1
    fi
}

# ===== 既存ファイルを .bak/ に退避 =====
backup_package() {
    local pkg="$1"
    local src rel target dest
    while IFS= read -r -d '' src; do
        rel="${src#"$DOTFILES_DIR/$pkg/"}"
        target="$TARGET_DIR/$rel"

        # 存在しなければ退避不要
        [[ -e "$target" || -L "$target" ]] || continue

        # 既にこの dotfiles へのリンクならスキップ
        if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$src")" ]]; then
            continue
        fi

        dest="$BACKUP_DIR/$pkg/$rel"
        mkdir -p "$(dirname "$dest")"
        mv "$target" "$dest"
        echo "  backup: $target -> $dest"
    done < <(find "$DOTFILES_DIR/$pkg" \( -type f -o -type l \) -print0)
}

main() {
    install_stow

    local dir pkg
    for dir in "$DOTFILES_DIR"/*/ "$DOTFILES_DIR"/.*/; do
        [[ -d "$dir" ]] || continue
        pkg="$(basename "$dir")"
        [[ "$pkg" == "." || "$pkg" == ".." ]] && continue
        is_ignored "$pkg" && continue

        echo "[$pkg]"
        backup_package "$pkg"
        stow -v --no-folding -d "$DOTFILES_DIR" -t "$TARGET_DIR" -R "$pkg"
    done

    echo "Done."
}

main "$@"
