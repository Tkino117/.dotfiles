# ~/.zshenv — 全ての zsh（非対話シェル含む）で読まれる

# Homebrew を /usr/bin より前に置く（macOS: /opt/homebrew, Linux: Linuxbrew）
# 非対話シェル（Claude Code など）でも効くよう .zshrc ではなくここに置く
typeset -U path
for p in /opt/homebrew /home/linuxbrew/.linuxbrew; do
  [[ -d $p/bin ]] && path=($p/bin $p/sbin $path)
done
unset p
