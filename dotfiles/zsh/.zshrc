# ~/.zshrc — macOS / Linux 共通

# ------------------------------------------------------------
# PATH
# ------------------------------------------------------------
typeset -U path fpath            # 重複を自動で除去
path=("$HOME/.local/bin" $path)  # Linux で sheldon などを置く場所

# ------------------------------------------------------------
# 履歴
# ------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt share_history          # 複数ターミナル間で履歴を共有
setopt extended_history       # 実行時刻も記録
setopt hist_ignore_all_dups   # 同じコマンドは古い方を消す
setopt hist_ignore_space      # 先頭スペースのコマンドは残さない
setopt hist_reduce_blanks     # 余分な空白を詰める
setopt hist_verify            # !! 展開後すぐ実行せず確認

# ------------------------------------------------------------
# 一般オプション
# ------------------------------------------------------------
setopt auto_cd                # ディレクトリ名だけで cd
setopt auto_pushd pushd_ignore_dups   # cd 履歴 (cd -<Tab>)
setopt pushd_minus            # cd - の順番を逆順に
setopt interactive_comments   # 対話中も # コメントを使える
setopt no_beep

# ------------------------------------------------------------
# 補完の見た目（compinit 自体は sheldon 側で実行）
# ------------------------------------------------------------
zstyle ':completion:*' menu select                         # 候補を矢印/hjkl で選ぶ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'        # 小文字入力で大文字にもマッチ
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zmodload zsh/complist

# ------------------------------------------------------------
# Vim 風キーバインド
# ------------------------------------------------------------
bindkey -v
KEYTIMEOUT=1                  # Esc でのモード切替を待たせない

# 挿入モードで「入力開始位置より前」も消せるようにする
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
# 挿入モードでもよく使う Emacs 系だけ残す
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line

# 入力途中の文字で履歴を前方一致検索（↑↓ と ノーマルモードの k/j）
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins '^[[A' up-line-or-beginning-search
bindkey -M viins '^[[B' down-line-or-beginning-search
bindkey -M viins '^P'   up-line-or-beginning-search
bindkey -M viins '^N'   down-line-or-beginning-search
bindkey -M vicmd 'k'    up-line-or-beginning-search
bindkey -M vicmd 'j'    down-line-or-beginning-search

# ノーマルモードで v を押すと $EDITOR でコマンドを編集
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# 補完メニュー内を hjkl で移動
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# モードに合わせてカーソル形状を変える（挿入=細線 / ノーマル=ブロック）
# ※ starship init より前に定義しておくと starship 側がこれを引き継ぐ
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    printf '\e[2 q'
  else
    printf '\e[6 q'
  fi
}
function zle-line-init { printf '\e[6 q' }
zle -N zle-keymap-select
zle -N zle-line-init
autoload -Uz add-zsh-hook
_cursor_block() { printf '\e[2 q' }
add-zsh-hook preexec _cursor_block   # コマンド実行中はブロックに戻す

# ------------------------------------------------------------
# プラグイン（sheldon）: completions → compinit → autosuggestions → highlighting
# ------------------------------------------------------------
if (( $+commands[sheldon] )); then
  eval "$(sheldon source)"
fi
bindkey -M viins '^F' autosuggest-accept   # 候補を確定（→ キーでも可）

typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'    # 存在するパスの色
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[comment]='fg=244'  # コメント色

# ------------------------------------------------------------
# プロンプト（starship）
# ------------------------------------------------------------
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# ------------------------------------------------------------
# fzf: Ctrl-R 履歴検索 / Ctrl-T ファイル / Alt-C ディレクトリ
# ------------------------------------------------------------
if (( $+commands[fzf] )); then
  if fzf --zsh >/dev/null 2>&1; then            # fzf 0.48 以降（brew 版など）
    source <(fzf --zsh)
  else                                          # 古い apt 版
    for f in /usr/share/doc/fzf/examples/{key-bindings,completion}.zsh; do
      [[ -r $f ]] && source "$f"
    done
    unset f
  fi
fi

# ------------------------------------------------------------
# 関数・エイリアス
# ------------------------------------------------------------
# yazi を終了したとき、そのディレクトリに cd する
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

# マシン固有の設定（git 管理しない）
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ------------------------------------------------------------
# zoxide（z <名前の一部> で移動 / zi で fzf 選択）— 最後に置く
# ------------------------------------------------------------
if (( $+commands[zoxide] )); then
  export _ZO_ECHO=1             # z / zi で移動したら移動先を表示（init より前に設定）
  eval "$(zoxide init zsh)"
fi
