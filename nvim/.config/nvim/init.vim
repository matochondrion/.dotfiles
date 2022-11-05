" --- PLUGINS
call plug#begin('~/.config/nvim/plugged')

" TODO: [ ] see jakewies: .init.vim plugins for things to try
" TODO: [ ] see jakewies: .init.vim Experiment with settings
" TODO: [ ] install coc-slime or some similar alternative

" Might need this? Not sure
"solargraph.commandPath": "/Users/richardmsachsjr/.gem/ruby/3.0.3/bin/solargraph",
" General
" Plug 'preservim/nerdtree' file explorer
Plug 'janko/vim-test' " easier testing
Plug 'vim-scripts/ReplaceWithRegister' " allows gr and grr to replace while keeping contents in register
Plug 'norcalli/nvim-colorizer.lua' " CSS etc inline color previews
Plug 'mattn/emmet-vim' " vim-emmet: expanding abbreviations similar to emmet
Plug 'tpope/vim-rhubarb' " Add `GBrowse` to github
Plug 'github/copilot.vim' " https://copilot.github.com/
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-ruby/vim-ruby' " For Facts, Ruby functions, and custom providers
Plug 'airblade/vim-gitgutter' "git icons in gutter
Plug 'kassio/neoterm' "send commands to REPL (like Slime)
Plug 'junegunn/vim-easy-align' "alignment plugin: https://github.com/junegunn/vim-easy-align

" Tim Pope
Plug 'tpope/vim-unimpaired' " Pairs of handy bracket mappings
Plug 'tpope/vim-fugitive' " Git tools
Plug 'tpope/vim-commentary' " Comment stuff
Plug 'tpope/vim-endwise' " Add `end` when writing ruby methods/iterators
Plug 'tpope/vim-surround' " surround text in tags, quotes, parens, etc.
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rails'

" Fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " https://github.com/junegunn/fzf
Plug 'junegunn/fzf.vim' " https://github.com/junegunn/fzf.vim, scroll preview with shift-up, shift-down

" Colors
Plug 'chriskempson/base16-vim' " Base16 is pretty standard, lots of options
Plug 'NLKNguyen/papercolor-theme' " PaperColor colorscheme, pretty good but strong folding colors
Plug 'srcery-colors/srcery-vim' " Srcery colorscheme is pretty good
Plug 'fcpg/vim-orbital' " orbital colorscheme is blue spacey, author also has warm themes
Plug 'folke/tokyonight.nvim', { 'branch': 'main' } " Color scheme
Plug 'balanceiskey/vim-framer-syntax',  { 'branch': 'main' } " framer-syntax colorscheme is balanced
Plug 'morhetz/gruvbox'

call plug#end()

" SETTINGS {{{
  " vim-polyglot suggests set nocompatible
  " neovim says this is always set, but when I explicitly set it, markdown
  " files are more responsive (faster)
  set nocompatible
  " don't shows line numbers
  set nonumber
  " display search matches as they are typed
  set incsearch
  " display incomplete command in lower right corner, i.e. the start of a motion
  set showcmd
  " don't unload a buffer when no longer shown in a window
  set hidden
  " ignore case when using search patterns
  set ignorecase
  " override ignorecase when pattern has uppercase chars
  set smartcase
  " sets at least 10 lines above and below the cursor
  set scrolloff=5
  " prevents swapfile
  set noswapfile
  " uses older regex engine: speeds scrolling
  " set re=1
  " patterns to ignore for file name completion
  set wildignore=log/**,*/node_modules/**,target/**,tmp/**,vendor/**,public/**,*.rbc,*.pyc,elm-stuff/**
  " num of spaces to use for autoindent
  set shiftwidth=2
  " rounds the indent spacing to the next multiple of shiftwidth"
  set shiftround
  " stops <CR> from indenting 4 spaces due to vim-polygot > vim-markdown plugins
  " https://github.com/plasticboy/vim-markdown/issues/126
  let g:vim_markdown_new_list_item_indent = 2
  " num of spaces to insert for tab
  set softtabstop=2
  " num of spaces a tab stands for
  set tabstop=2
  " use spaces instead of tabs in insert mode
  set expandtab
  " allows persistent undo
  " set undodir=~/.vim/undodir
  " set undofile
  " opens all vert splits to the right
  set splitright
  " prevents wrapping of code
  " https://stackoverflow.com/questions/1290285/why-cant-i-stop-vim-from-wrapping-my-code
  " set wrap!
  set nowrap
  " when lines are soft wrapped, indent if first line indented
  " https://vi.stackexchange.com/questions/14932/the-indent-of-wrapped-lines
  set breakindent breakindentopt=sbr,list:-1 linebreak
  " Update when have time...used to match bullets. this should be set up per
  " filetype probably.
  " https://vi.stackexchange.com/questions/14932/the-indent-of-wrapped-lines
  let &formatlistpat = '^line\s\+\d\+:\s*'
  set linebreak "Not sure why this would never be set?
  set tw=79
  set colorcolumn=+1
  " Enable mouse for all modes
  set mouse=a
  " always uses clipboard register
  set clipboard=unnamedplus
  " set termguicolors
  if (has("termguicolors"))
    set termguicolors
  endif
  " use the indent of the previous line for a newly created line
  set autoindent
  " disables initial folds, `zi` toggles on/off
  set nofoldenable
  " uses {{{}}} with folds by default
  set foldmethod=marker
  " refreshes window less
  set lazyredraw
  set background=dark
  set shell=/bin/zsh
  " Fix `gq` wrapping so no new bullets when wrapped for markdown files
  " https://github.com/plasticboy/vim-markdown/issues/390
  autocmd BufRead,BufNewFile *.md setlocal comments=fb:>,fb:*,fb:+,fb:-
  " Fold diffs in git commit for fugitive"
  " https://github.com/tpope/vim-fugitive/issues/146
  autocmd FileType gitcommit set foldmethod=syntax
  " Enable scss-lint checking using Syntastic"
  let g:syntastic_scss_checkers = ['scss_lint']
  " Use netrw tree listing mode
  " (Causes issues when using Marks to jump to files/directories on remote
  " servers)
  " let g:netrw_liststyle=3
" }}}

" FUNCTIONS {{{
  function TermBelow()
    execute "below new"
    execute "resize 12"
    execute "terminal"
    execute ":startinsert"
  endfunction

  function TermRight()
    execute "vsplit"
    execute "terminal"
    execute ":startinsert"
  endfunction

  function! FzfSpellSink(word)
    exe 'normal! "_ciw'.a:word
  endfunction

  function! FzfSpell()
    let suggestions = spellsuggest(expand("<cword>"))
    return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
  endfunction

  nmap <leader>= :call FzfSpell()<CR>
" }}}

" COLORS & SYNTAX HIGHLIGHTING {{{
  " causes vim to attempt to determine what type of file curr file is
  " and load options and indentation for that file type
  filetype plugin indent on
  " enables syntax highlighting
  syntax enable
  " Possible fix for when syntax highlighting stops working
  " https://github.com/vim/vim/issues/2790
  set redrawtime=10000

  colorscheme base16-atelier-heath
  " colorscheme base16-atelier-cave
  " colorscheme base16-3024
  " colorscheme tokyonight
  " colorscheme base16-default-dark
  " colorscheme PaperColor
  " colorscheme framer_syntax_dark
  " colorscheme orbital

  " " colorscheme srcery
  " " https://github.com/srcery-colors/srcery-vim"
  " colorscheme srcery
  " " Set the terminal background in vim to hard black
  " g:srcery_hard_black_terminal_bg = 0

  " " default
  " " When using 'default', change the floating menu bg color:
  " highlight PMenu ctermbg=1
  " highlight PMenu guibg=Gray
  " full instructions for getting truecolor to work with iterm:
  " https://tomlankhorst.nl/iterm-tmux-vim-true-color/
  " stopgap settings to get a daker background:
  " https://github.com/dracula/vim/issues/96

  " set background to blacklist
  highlight Normal ctermbg=black guibg=black
  map <C-w>b :highlight Normal ctermbg=0 guibg=black<CR>

  " highlight trailing whitespace"
  highlight ExtraWhitespace ctermbg=92 guibg=#dbb32d
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match ExtraWhitespace /\s\+$/

  " define line highlight color:
  highlight LineHighlight ctermbg=darkblue guibg=darkblue

  " turn off markdownLinkText underlining (works for Base16 colorschemes since
  " they define a 'Keyword' highlight group)
  hi link markdownLinkText Keyword
  " hi link markdownLinkText markdownUrlTitle

  " define search highlight color:
  hi Search guibg=MidnightBlue guifg=wheat
  hi Search cterm=NONE ctermfg=grey ctermbg=blue
  " https://github.com/norcalli/nvim-colorizer.lua setup"
  lua require'colorizer'.setup()

  " statusline
  set statusline=                               " reset
  set statusline=%n\                            " Buffer number
  set statusline+=%{FugitiveStatusline()}\      " Git status
  set statusline+=%f%m%r%h%w\                   " File name, modified, help-reads-only, preview"
  set statusline+=[%{strlen(&fenc)?&fenc:&enc}] " Encoding
  set statusline+=%=                            " Switch to the right side
  set statusline+=\ [%v\ %l\/%L]                " column:line/lines"
" }}}

" PLUGIN SETTINGS {{{
  filetype plugin on

  " make sure git gutter updates (prevents double signs, "++")
  " autocmd BufWritePost * GitGutter

  " " nerdtree
  " let g:NERDTreeWinSize=50
  " let NERDTreeShowHidden=1
  " let g:NERDSpaceDelims=1

  " silver searcher
  if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor
  endif

  " Emmet: Remap the default `<C-Y>` leader to `<C-w>e`:"
  " Note that the trailing `,` still needs to be entered, so the new keymap
  " would be `<C-w>e,`.
  let g:user_emmet_leader_key='<C-w><C-e>'
" }}}

" REMAP {{{
  let mapleader="\<SPACE>"

  " erb expansions, based off Emmet leader
  imap <C-w>< <%=  %><esc>hhi
  " imap <C-w><C-e>< <%=  %><esc>hhi

  " Vim init.vim:
  nmap <leader>I :source $MYVIMRC<CR>
  nmap <leader>i :edit $MYVIMRC<CR>

  " " Jump to [tT] tag
  " nmap tt /tT\><CR>
  " nmap tT ?tT\><CR>

  " " Jump to bullet Item
  " nmap ti /^\s*\*/e<CR>
  " nmap tI ?^\s*\*/e<CR>

  " Jump to daSh item
  nmap ts /^\s*\-/e<CR>
  " nmap 'S ?\-\s<CR> " S reserved for Status

  " Jump to start of line (mnemonic to the left of $)
  nmap <S-e> 0
  nmap z^ 0

  " Window Commands
  nnoremap <C-w><BS> :tabclose<CR>
  nnoremap <C-w><Esc> :tabedit<CR>
  nnoremap <C-t> :tab sp<CR>
  nnoremap <C-e> :Explore<CR>

  " Buffers
  "write and quit buffer
  nmap <leader>W :wq<CR>
  nmap <leader>w :w<CR>
  nmap <leader>v :vsplit<CR>
  nmap <leader>s :split<CR><C-j>
  nmap <leader>o :only<CR>
  " delete all bufers | open last closed buffer | delete [NO NAME] buffer
  " need to escape the pipe, \|
  nmap <leader>O :%bd\|e#\|bd#<CR>
  " quit buffer in normal mode
  noremap <leader>q :q<CR>
  " close buf in current split, leave split open, change to next buffer
  noremap <leader>Q :w<CR>:bp<CR>:bd #<CR>
  " Quickly switch to last buffer
  " close all windows and save splits
  " noremap <leader>x :wqa<CR>
  " show buffers
  nmap <leader>b :Buffers<CR>
  " Toggle Previous Buffer
  nmap <C-y> <C-^>

  " Terminal
  " open terminal: mnemonic: "to terminal"
  noremap <leader>t :terminal<CR>
  noremap <leader>m :terminal<CR>
  " open terminal in vertical split
  noremap <leader>V :call TermRight()<CR>
  " use Esc to enter normal mode for terminal (useful for vim-test)
  if has("nvim")
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au FileType fzf tunmap <buffer> <Esc>
  endif

  " Folding
  nnoremap ff :setlocal foldmethod=indent<cr>zM
  nnoremap fe :setlocal foldmethod=expr<cr>zM
  nnoremap fm :setlocal foldmethod=marker<cr>zM
  nnoremap fs :setlocal foldmethod=syntax<cr>zM

  " Nerdtree
  " nnoremap <leader>e :NERDTreeToggle<CR>
  " nnoremap <leader>r :NERDTreeFind<CR>
  " stop accidentally entering ex-mode
  " noremap Q <ESC>

  " Formatting
  " Resync formatting
  " map <leader>s :syntax sync fromstart<CR>

  " Column width: Sometimes we don't want to wrap.
  nnoremap <leader>0 :set textwidth=0<CR>
  nnoremap <leader>7 :set textwidth=79<CR>
  nnoremap <leader>8 :set textwidth=79<CR>
  nnoremap <leader>9 :set textwidth=99<CR>

  " Split width
  nnoremap yoA :vertical resize\|resize<CR>
  nnoremap yoa <C-w>=
  nnoremap yom <C-w>15>
  nnoremap yol <C-w>5<
  nnoremap yoe :vertical resize 85<CR>

  " highlight the current line (mnemonic: fold highlight):
  nnoremap fh :call matchadd('LineHighlight','\%'.line('.').'l')<CR>
  " clear all the highlighted lines (mnemonic: fold clear)
  nnoremap fc :call clearmatches()<CR>

  " Line completions"
  imap <C-l> <C-x><C-l>

  " Select entire buffer
  nnoremap vy ggVG

  " remove content from line
  nnoremap dc 0<S-d>
  " insert formatted date"
  map <leader>dt :r !date "+\%Y-\%m-\%d \%a"<CR>kJ$

  " Pane Navigation
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
  " map <C-s> <C-w>s "might be good to use instead of <leader>s"
  " map <C-S> <C-w>v "might be good to use instead of <leader>v"

  " G leaders - mostly Git"
  " Jump to end quickly without timeout since G is remapped for git
  map GG <C-end>0
  " fzf commits
  map Gc :Commits<CR>
  " fzf commits for current buffer only
  map GC :BCommits<CR>
  " fzf git files
  map Gf :GFiles<CR>
  " fzf git status
  map GF :GFiles?<CR>
  " fzf commits for current buffer only
  " vim-fugitive
  " diff between current file in working directory and the version in Index
  map Gdi :Gvdiff<CR>
  " diff between current file and file from previous commit
  map Gdf :Gvdiff !~1<CR>
  " diff between current file and file in main
  map Gdm :Gvdiff main:%<CR>
  " List of files with diffs working tree to main:
  map Gdn :Git diff --name-status main --<CR>
  " Git difftool between current branch and main using quickfix
  " Can navigate quickfix and see gutter changes or `gdm` for diffsplit
  map Gdt :Git difftool main --<CR>
  " Git difftool between, diffs open in tabs
  map Gs :G<CR>
  map GS :G<CR>:q<CR>
  map Gr :Gread<CR>
  map Ga :Gwrite<CR>
  map Gw :Gwrite!<CR>
  map Ge :Gedit<CR>
  map Gp :G push<CR>
  map Gb :G blame<CR>

  " Navigate QuickFix with [q and ]q"
  " History of commits on current branch
  map Glb :Gclog master..<CR>
  " History of current file. Use `Glog` for all branch history:
  map Glf :0Gclog<CR>
  " Commit history:
  map Gll :Gclog<CR>
  " Stash log"
  " You can browse stashes and apply using cz<Space>apply<Space><C-R><C-G>
  map Gls :Glog -g stash<CR>

  nnoremap Gx :GBrowse<CR>
  xnoremap Gx :'<'>GBrowse<CR>
  nnoremap Gy :GBrowse!<CR>
  xnoremap Gy :'<'>GBrowse!<CR>

  map Gdy :Git difftool -y master --<CR>
  map Gm :MerginalToggle<CR>

  " GitGutter pneumonic 'git hunk'
  nmap Ghs <Plug>(GitGutterStageHunk)
  nmap Ghu <Plug>(GitGutterUndoHunk)
  nmap Ghp <Plug>(GitGutterPreviewHunk)
  " fzf and searching
  " files
  map <leader>f :Files<CR>
  " search files with word under cursor (like gf, but with wildcard directory)
  map gF :call fzf#vim#files('.', {'options':'--query '.expand('<cword>')})<CR>
  " trailing space is intentional
  map <leader>g :Ag 
  " trailing space is intentional
  map <leader>F :find 
  " Ag search for word under cursor
  noremap <leader>a :exe ':Ag ' . expand('<cword>')<CR>
  " fzf history
  map <leader>z :History<CR>
  " fzf windows
  map <C-w>w :Windows<CR>
  map <C-w><C-w> :Windows<CR>
  " exclude files in .gitignore:"
  " source: https://rietta.com/blog/hide-gitignored-files-fzf-vim/
  nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

  " Testing
  " vim-test nearest: single key
  map <leader>n :w<CR>:TestNearest<CR>
  " vim-test file: single key
  map <leader>N :w<CR>:TestFile<CR>

  " To jump between hunks you can use ]c and [c. Since I don’t really use the
  " return and backspace keys in normal mode I have mapped those instead:
  " https://til.hashrocket.com/posts/1xc8h959tq-jump-between-git-hunks-in-vim-with-vim-gitgutter
  nnoremap <silent> <cr> :GitGutterNextHunk<cr>
  nnoremap <silent> <backspace> :GitGutterPrevHunk<cr>

  " Sign column(gutter) on/off similar to Unimpaired. Mnemonic: gutter
  " Don't currently have a toggle
  nnoremap <silent> [og  :set scl=no<CR>   " force the signcolumn to disappear
  nnoremap <silent> ]og  :set scl=auto<CR> " return the signcolumn to the default behaviour

  "turn syntax highlight on and off...good for diff mode"
  nnoremap [oy :syntax on<CR>
  nnoremap ]oy :syntax off<CR>
  nnoremap yoy :syntax off<CR>
  nnoremap yoY :syntax on<CR>

  " Copy a file: https://salferrarello.com/vim-netrw-duplicate-file/
  nnoremap <silent> <Leader>dd :clear<bar>silent exec "!cp '%:p' '%:p:h/%:t:r-copy.%:e'"<bar>redraw<bar>echo "Copied " . expand('%:t') . ' to ' . expand('%:t:r') . '-copy.' . expand('%:e')<cr>

  " Copy a file path to unamed register
  nmap <leader>cp :let @+ = expand("%")<cr>
  " Easy-Align:
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
" }}}

" AUTOCMD & COMMAND {{{
  augroup init.vim
    " clear this group to prevent accidental double-loading
    autocmd!

    " change indentation for python
    autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8

    " don't autocomment next line
    " autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " set spell for text files
    autocmd FileType markdown,mkd,gitcommit,html setlocal spell

    " terminal
    " turn off highlight past certain length for terminal buffers
    autocmd TermEnter,TermOpen * hi clear ErrorMsg

    " sets options for terminal
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber signcolumn=no

    " " ttimeout & ttimeoutlen prevent latency in terminal due to waiting for leader
    " autocmd TermEnter * setlocal ttimeout ttimeoutlen=0 timeoutlen=0

    " " experimental resets timeoutlen and timeoutlen to defautocmdlts if leave terminal
    " autocmd TermLeave * set timeoutlen=1000 ttimeoutlen=1

    " leaves insert mode when leaving terminal buffer
    autocmd TermLeave * :stopinsert

    " avoid terminal buffers when cycling through buffers
    " https://www.reddit.com/r/vim/comments/8njgul/is_it_possible_to_skip_over_terminal_buffers_when/
    " https://vi.stackexchange.com/questions/20751/hide-terminal-buffer-from-buffer-list
    " autocmd TermOpen * if bufwinnr('') > 0 | setlocal nobuflisted | endif

    " starts insert mode when entering terminal buffer
    " autocmd BufWinEnter,WinEnter term://* startinsert
  augroup end
" }}}

" COC {{{
  " coc extensions
  " TODO: Research what is actuall needed
  let g:coc_global_extensions = [
        \'coc-prettier',
        \'coc-solargraph',
        \'coc-eslint',
        \'coc-snippets',
        \'coc-pairs',
        \'coc-tsserver',
        \'coc-tabnine',
        \'coc-css',
        \'coc-html',
        \'coc-json',
        \]

  " Set internal encoding of vim, not needed on neovim, since coc.nvim using some
  " unicode characters in the file autoload/float.vim
  set encoding=utf-8
  " coc.nvim some language servers have issues with backup files, see #649
  set nobackup
  set nowritebackup
  " coc.nvim better display for messages. Setting to 1 creates bug - have to
  " hit enter to continue
  set shortmess=a
  set cmdheight=1
  " coc.nvim bad experience for diagnostic messages with default of 4000.
  set updatetime=200
  " coc.nvim don't give |ins-completion-menu| messages.
  set shortmess+=c
  " show signcolumns if needed with width of 2
  set signcolumn=auto:2

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> grf <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>=  <Plug>(coc-format-selected)
  nmap <leader>=  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  " xmap <leader>a  <Plug>(coc-codeaction-selected)
  " nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  " nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  " nmap <leader>qf  <Plug>(coc-fix-current)

  " Run the Code Lens action on the current line.
  nmap <leader>cl  <Plug>(coc-codelens-action)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocActionAsync('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics.
  " nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  " nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  " nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

  " Open file under curser in Quickfix Window
  nnoremap <silent> \p  :<C-u>CocListResume<CR>

  " coc.nvim
  " Float window off by default because annoying and sometimes causes crashes
  " when testing. turn float on and off. mnemonic: d: diagnostic
  nmap yde :call coc#config('diagnostic.messageTarget', 'echo')<CR>
  nmap ydf :call coc#config('diagnostic.messageTarget', 'float')<CR>
" }}}
"
" COPILOT {{{
  " let g:copilot_filetypes = {
  "       \ 'markdown': v:true,
  "       \ }

  " Github Copilot - Doesn't seem to work
  " noremap <C-}> <Plug>(copilot-next)
  " noremap <C-{> <Plug>(copilot-previous)

  "" Disable Copilot by default
  let g:copilot_enabled = v:false
" }}}

" NEOTERM {{{
" some setup advice: https://austeretechnology.wordpress.com/2017/07/18/a-ruby-repl-workflow-with-neovim-and-neoterm/
  let g:neoterm_repl_ruby='pry'
  let g:neoterm_autoscroll = '1' " scroll to bottom on new input
  " let g:neoterm_default_mod='belowright' " https://github.com/kassio/neoterm/issues/257 | https://github.com/kassio/neoterm/blob/master/doc/neoterm.txt#L195 | https://github.com/kassio/neoterm/blob/master/doc/neoterm.txt#L250-L254
  let g:neoterm_default_mod='vertical' " https://github.com/kassio/neoterm/issues/257 | https://github.com/kassio/neoterm/blob/master/doc/neoterm.txt#L195 | https://github.com/kassio/neoterm/blob/master/doc/neoterm.txt#L250-L254

  nnoremap <silent> <C-c><C-c> <Plug>(neoterm-repl-send-line)
  nnoremap <silent> <C-c><C-m> <Plug>(neoterm-repl-send)
  vnoremap <silent> <C-c><C-c> <Plug>(neoterm-repl-send)
" }}}
