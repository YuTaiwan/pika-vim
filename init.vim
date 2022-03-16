"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ________         _
"  |  ____  \   _   | |
"  | |____) |  (_)  | |   _
"  |  ______/   _   | |__/ /   _____
"  | |         | |  |  _  /   /  _  \
"  | |         | |  | | \ \  |  (_)  \
"  |_|         |_|  |_|  \_\  \____/\_\
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: LeoMao
"
" Version: 6.0.0
"
" Sections:
"    -> Map leader settings
"    -> Plugin Settings
"    -> General
"    -> VIM UI
"    -> Colors and Fonts
"    -> Files, backups and undo
"    -> Text, tab and indent related
"    -> Fold Settings
"    -> Visual mode related
"    -> Command mode related
"    -> Moving around, tabs and buffers
"    -> Statusline
"    -> Tags
"    -> Key mappings
"    -> Cope
"    -> Language section
"    -> grep
"    -> MISC
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" => General {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500
" shell
set shell=$SHELL

" compatibility for vim and neovim
if !has('nvim')
  set nocompatible
  " set term inside tmux for xterm-key on (nvim doesn't need this)
  if &term =~ '^screen\|^tmux' && exists('$TMUX')
    if &term =~ '256color'
      set term=xterm-256color
    else
      set term=xterm
    endif
  endif
  if &term =~ '256color'
    set t_ut=
  endif
  if exists('$TMUX')
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
endif

" True color support
" If your terminal doesn't support true color,
" set notermguicolors in your local.vim
if has('termguicolors')
  set termguicolors
endif

" Neovim settings
let g:python3_host_prog = '/usr/bin/python3'

" Enable filetype plugin (called by vim-plug)
"filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread

" Clear auto cmd for reload vimrc
autocmd!
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Map leader settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set map leader to ' '
let mapleader = "'"
let maplocalleader = "'"
let g:mapleader = "'"
let g:maplocalleader = "'" 
runtime custom/leader.vim
" }}}
" => Plugin settings {{{i
""""""""""""""""""""""""""""""
" include matchit plugins in vim
if !exists('g:loaded_matchit')
  runtime macros/matchit.vim
endif

" --- vim-plug plugin --- {{{
execute plug#begin()

" NOTE:
" - leomao/lightline-pika is my personal settings.

Plug 'leomao/pikacode.vim'
Plug 'itchyny/lightline.vim'
Plug 'leomao/lightline-pika'

Plug 'leomao/python-syntax', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
Plug 'fatih/vim-go', { 'for' : 'go' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'mattn/emmet-vim', { 'for': [ 'html', 'css' ] }
Plug 'digitaltoad/vim-pug', { 'for': 'pug' }
Plug 'cakebaker/scss-syntax.vim', { 'for': [ 'scss', 'sass' ] }
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
Plug 'pangloss/vim-javascript', { 'for': [ 'javascript', 'javascript.jsx', 'html' ] }
Plug 'mxw/vim-jsx', { 'for': [ 'javascript', 'javascript.jsx', 'html' ] }
Plug 'lervag/vimtex', { 'for': 'tex' }

Plug 'jlanzarotta/bufexplorer'
Plug 'editorconfig/editorconfig-vim'
if !filereadable('/usr/share/vim/vimfiles/plugin/fzf.vim')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
endif
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'

Plug 'psf/black', { 'branch': 'stable' }

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'ojroques/nvim-lspfuzzy'
  set completeopt=menuone,noselect
endif

"include custom plugin
runtime custom/plugin.vim

execute plug#end()
" }}}

" --- netrw plugin (built-in) --- {{{
let g:netrw_liststyle = 3
let g:netrw_altv = 1
" }}}

" --- fzf plugin --- {{{
nnoremap <leader>ff <ESC>:FZF<CR>
nnoremap <leader>bf <ESC>:Buffers<CR>

" Augmenting Rg command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Rg  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Rg! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" }}}

" --- editorconfig plugin --- {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
" }}}

" --- Buffer plugin --- {{{
let g:bufExplorerSortBy = 'name'
let g:bufExplorerShowRelativePath = 1
let g:bufExplorerShowNoName = 1
" }}}

" --- vimtex --- {{{
let g:vimtex_fold_enabled = 0
let g:vimtex_imaps_leader = ';'
let g:vimtex_quickfix_ignore_filters = {
      \ 'overfull' : 0,
      \ 'underfull' : 0,
      \ 'specifier changed to' : 0,
      \ 'xparse/redefine-command' : 0,
      \ 'script-not-exist' : 0,
      \ }
" }}}

" --- NERD Commenter plugin --- {{{
let g:NERDSpaceDelims = 0
let g:NERDRemoveExtraSpaces = 1
"let g:NERDCreateDefaultMappings = 0
"map <leader>cc <plug>NERDCommenterComment
"map <leader>cu <plug>NERDCommenterUncomment
"map <leader>c<space> <plug>NERDCommenterToggle
" }}}

" --- undotree plugin --- {{{
noremap <silent><F5> <ESC>:UndotreeToggle<CR>
" }}}


" --- Emmet --- {{{
" let g:user_zen_leader_key = '<c-m>'
let g:user_emmet_install_global = 0
au Filetype html,css EmmetInstall
" }}}

" --- lightline --- {{{
let g:lightline = {
      \ 'colorscheme': 'pikacode'
      \ }
let g:lightline_pika_patchfont = {
      \ 'leftsep': "\ue0b0",
      \ 'leftsubsep': "\ue0b1",
      \ 'rightsep': "\ue0b2",
      \ 'rightsubsep': "\ue0b3",
      \ 'branch': "\ue0a0",
      \ 'linecolumn': "\ue0a1",
      \ 'readonly': "\ue0a2",
      \ }
" }}}

" --- vim-go --- {{{
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" }}}

" --- nvim-lspconfig --- {{{
if has('nvim')
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "rls", "clangd", "pylsp"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
-- rust, rls
nvim_lsp.rls.setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
}
nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  settings = {
    configurationSources = {"flake8"},
    pylsp = {
      plugins = { 
          isort = { enabled = false },
          -- black = { enabled = true },
          -- flake8 = {enabled = true },
          pycodestyle = {enabled = false },
          pyflakes = {enabled = false },
          pylsp_mypy = {enabled = false },
      },
    },
  },
}
local saga = require 'lspsaga'
saga.init_lsp_saga()
require('lspfuzzy').setup {}
EOF
endif
" }}}

" --- nvim-compe --- {{{
if has('nvim')
lua << EOF
require('compe').setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}
EOF

  inoremap <silent><expr> <C-n> compe#complete()
  inoremap <silent><expr> <CR>  compe#confirm('<CR>')
  "inoremap <silent><expr> <C-e> compe#close('<C-e>')
  inoremap <silent><expr> <C-f> compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d> compe#scroll({ 'delta': -4 })

  set shortmess+=c
endif

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => VIM UI {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical
set so=7
set wildignorecase
set wildmenu "Turn on WiLd menu
set guitablabel=%t
" stuff to ignore when tab completing
set wildignore=*.o,*.obj,*~,*.synctex.gz,*.pdf

" let alt key can be mapped
set winaltkeys=no
set ruler "Always show current position

if has('gui_running')
  set guioptions-=T "remove toolbar
  set guioptions-=m "remove menubar
  set guioptions-=r "remove scrollbar
endif

" line number will be highlighted if set rnu
"set cursorline " highlight current line *Slow*
set cmdheight=1 " The commandbar height
"set showcmd " display what command was typed
set noshowmode " display current mode

set nu " line number
set rnu " line number (relative number)
set hid " Change buffer - without saving
" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,[,]
" the cursor can be positioned where there is no actual character
" in the visual mode.
set virtualedit=block

set ignorecase "Ignore case when searching
set smartcase

set hlsearch "Highlight search things
set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don't redraw while executing macros
set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=0 "How many tenths of a second to blink
" time out of mappings
set timeout
set ttimeoutlen=10
" No sound on errors
set novisualbell
set noerrorbells
set tm=500

set mouse=a
if !has('nvim')
  set t_vb=
  set ttymouse=xterm2
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Colors, Fonts, Encoding {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on " Enable syntax highlight
set background=dark
colorscheme pikacode
" Set font according to system
if has('gui_running')
  if has('win32') || has('win64')
    set gfn=Consolas:h16
  else
    set gfn=Monospace\ 16
  endif
endif
set fileencodings=utf8
set encoding=utf8
" format options
set fo+=Mm " for multi btye character
set fo+=crql
set fo-=t
set ffs=unix,dos,mac " Default file types
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Files, backups and undo {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

" Persistent undo
if has('persistent_undo')
  set undodir=$HOME/.vim/.undodir
  set undofile
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Text, tab and indent related {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set smarttab

set cino+=g0.5s,h0.5s,(0,W2s

" line break on 80 characters
set tw=125
" color column after 'textwidth'
set colorcolumn=+1

set ai "Auto indent
set wrap " wrap lines
"set nowrap " don't wrap lines
" set si " set smart indent
set listchars=trail:~,precedes:<,extends:>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Fold Settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable
set foldlevelstart=10
set fdm=syntax
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Visual mode related {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Really useful!
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

vnoremap <silent> * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
vnoremap <silent> @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Command mode related {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set current path when vim start
autocmd VimEnter * cd %:p:h
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Moving around, windows, tabs and buffers {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0
noremap 0 ^

" Treat long lines as break lines (useful when moving around in them)
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
  else
    echo "Wrap ON"
    setlocal wrap
    setlocal display+=lastline
  endif
  call SetWrapKeyMapping()
endfunction

function! SetWrapKeyMapping()
  if &wrap
    nnoremap  <buffer> <silent> k gk
    nnoremap  <buffer> <silent> j gj
    nnoremap  <buffer> <silent> 0 g^
    nnoremap  <buffer> <silent> $ g$
    nnoremap  <buffer> <silent> <Up>   gk
    nnoremap  <buffer> <silent> <Down> gj
    nnoremap  <buffer> <silent> <Home> g<Home>
    nnoremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <Esc>gka
    inoremap <buffer> <silent> <Down> <Esc>gja
    inoremap <buffer> <silent> <Home> <Esc>g<Home>i
    inoremap <buffer> <silent> <End>  <Esc>g<End>a
    onoremap <buffer> <silent> j gj
    onoremap <buffer> <silent> k gk
  else
    silent! nunmap <buffer> k
    silent! nunmap <buffer> j
    silent! nunmap <buffer> 0
    silent! nunmap <buffer> $
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
    silent! ounmap <buffer> j
    silent! ounmap <buffer> k
  endif
endfunction

au BufRead,BufNewFile * call SetWrapKeyMapping()
noremap <silent><F3> :call ToggleWrap()<CR>

" inoremap <C-l> <Del>

nnoremap <C-down>  <C-w>j
nnoremap <C-left>  <C-w>h
nnoremap <C-right> <C-w>l
nnoremap <C-up>    <C-w>k

nnoremap <leader>bd :bd<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bn :bn<CR>

" don't jump to the begin of the line
set nosol

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Statusline {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the statusline
set laststatus=2

" Format the statusline
"set statusline=\ %f%m%r%h\ %w\ %=%y\ %{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\"}\ %3l/%4L:%3c
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Tags {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au Filetype cpp setl tags+=~/.vim/tags/cpptags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Key mappings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set pastetoggle=<F2>

" increase and decrease number under the cursor
nnoremap + <C-a>
nnoremap - <C-x>

set clipboard+=unnamed

" Move lines of text using CTRL+[jk]
" nnoremap <C-k> :m-2<CR>:echo "move line up"<CR>
" vnoremap <C-j> :m'>+<CR>:echo "move block down"<CR>gv
" vnoremap <C-k> :m'<-2<CR>:echo "move block up"<CR>gv
" nnoremap <C-j> :m+<CR>:echo "move line down"<CR>

nnoremap <silent><leader>/ :nohl<CR>

" left hand esc
nnoremap <C-e> <ESC>
inoremap <C-e> <ESC>
vnoremap <C-e> <ESC>
snoremap <C-e> <ESC>

inoremap jk <ESC>
vnoremap jk <ESC>

" smarter command line
cnoremap <c-n>  <down>
cnoremap <c-p>  <up>

" Fast saving
nnoremap <leader>w :w!<CR>
" save with sudo
command! -nargs=0 Wsudo :w !sudo tee > /dev/null %

noremap <silent><F9> <ESC>:wa!<CR>:make<CR><CR>:cw<CR>

" check the syntax group under the cursor
function! ShowHiGroup()
  echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<'
    \ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
    \ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'
endfunction
noremap <S-F7> :call ShowHiGroup()<CR>
" workaround for neovim
noremap <F19> :call ShowHiGroup()<CR>

" formatting
nnoremap <space>f :Black<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Cope {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
noremap <silent><F8> <ESC>:call QFSwitch()<CR>
function! QFSwitch()
  redir => ls_output
  execute ':silent! ls'
  redir END

  let exists = match(ls_output, '[Quickfix List')
  if exists == -1
    execute ':copen'
  else
    execute ':cclose'
  endif
endfunction

noremap <silent><leader>cn :cn<CR>
noremap <silent><leader>cp :cp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => language section {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --- python --- {{{
let python_highlight_all = 1
let python_no_parameter_highlight = 1
" }}}
" --- latex --- {{{
let g:tex_flavor = 'latex'
let g:tex_fast = 'mm'
" }}}
" --- haskell --- {{{
let hs_highlight_boolean = 1
let hs_highlight_types = 1
" }}}
" --- bison/yacc --- {{{
let g:yacc_uses_cpp = 1
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
" => Load custom settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()
runtime custom/local.vim
" }}}
" vim:fdm=marker:foldlevel=0
