" 基本設定
set nocompatible        " Vi互換モードをオフ（Vimの機能を有効化）
set encoding=utf-8      " エンコーディングをUTF-8に設定

" ビープ音を無効化
set belloff=all 

"表示設定
set number              " 行番号を表示
set ruler               " カーソル位置を表示
set title               " ウィンドウのタイトルを設定
set showmatch           " 対応する括弧を表示
set wrap                " 長い行を折り返す
set showcmd             " 入力中のコマンドを表示
set laststatus=2        " ステータスラインを常に表示
set virtualedit=all     " カーソルを文字が存在しない場所にも移動可能に

" 検索設定
set hlsearch            " 検索結果をハイライト
set ignorecase          " 検索時に大文字・小文字を区別しない
set smartcase           " 検索パターンに大文字が含まれる場合は大文字・小文字を区別
set incsearch           " インクリメンタルサーチ（検索中に結果を表示）

" 編集設定
set autoindent          " 自動インデント
set smartindent         " スマートインデント
set tabstop=4           " タブ幅を4スペースに設定
set shiftwidth=4        " 自動インデントの幅を4スペースに設定
set expandtab           " タブをスペースに変換
set backspace=indent,eol,start  " バックスペースでインデントや改行を削除可能に

" その他の便利な設定
syntax enable           " シンタックスハイライトを有効化
set wildmenu            " コマンドラインの補完
set mouse=a             " マウスを有効化（全モードで）
set clipboard=unnamed   " クリップボードを共有

" バックアップファイルを作成しない
set nobackup
set nowritebackup
set noswapfile

" キーマッピング
" ESCキーの代わりにjjでノーマルモードに戻る
inoremap jj <ESC>

" 見た目の行で移動（折り返しがあっても自然に上下左右移動）
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk



" 行末の空白を表示
"set listchars=tab:>-,trail:~
"set list

" ファイルタイプ検出と自動インデント
filetype plugin indent on

" カラースキーム設定
colorscheme torte      " デフォルトで存在



" GUIフォント設定
set guifont=Consolas:h16  " GUIモードでConsolas 16ポイントフォントを使用
set guifontwide=MS_Gothic:h16:cSHIFTJIS

" カーソル設定
set guicursor=n:blinkon0,i-v-c:ver25-Cursor/lCursor-blinkwait300-blinkoff200-blinkon250  " ノーマルモードでは点滅なし、挿入・ビジュアル・コマンドモードでは下付四角形で点滅

 " 通常モードで行を移動
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==

" 挿入モードで行を移動
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi

" ビジュアルモードで選択範囲を移動
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" oを改行に
"nnoremap o :put =''<CR>
"nnoremap O :put! =''<CR>


