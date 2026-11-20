## 環境構築手順（自動）
```zsh
git clone https://github.com/tkino117/dotfiles.git ~/.dotfiles
~/.dotfiles/sync.sh 
```

### 手動の場合
1. `~/` に .dotfiles をクローン
2. stow をインストール
3. 元の設定ファイルを退避
4. `cd ~/.dotfiles` 
5. `stow bash`, `stow zsh` などで必要な設定のシンボリックリンクを作成
   （指定フォルダ -> 親フォルダ へのリンクがデフォルトで設定される）

## 原則
* 異なるツールは異なるディレクトリで管理
* 環境による設定は異なるディレクトリで管理
