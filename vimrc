" Much of this is stolen from github.com/drmikehenry/vimfiles

" Brackets are randomly highlighted for reasons I don't understand
augroup coloroverride
    autocmd!
    autocmd ColorScheme * highlight ColorColumn ctermbg=16
augroup END
autocmd BufWinEnter * highlight ColorColumn ctermbg=16

call plug#begin('~/.vim/plugged')
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rust-lang/rust.vim'
Plug 'majutsushi/tagbar'
Plug 'Shougo/deoplete.nvim'
Plug 'kergoth/vim-bitbake'
call plug#end()

if v:version >= 800
    let g:deoplete#enable_at_startup = 1
    call deoplete#enable()
elseif has('lua')

    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'
    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    "inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
endif

let mapleader = ','

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


" -------------------------------------------------------------
" bufmru
" -------------------------------------------------------------

" Set key to enter BufMRU mode (override this in vimrc-before.vim).
if !exists("g:bufmru_switchkey")
    " NOTE: <C-^> (CTRL-^) also works without shift (just pressing CTRL-6).
    let g:bufmru_switchkey = "<C-^>"
endif

" Use <Space><Space> as an additional map for BufMRU mode, aiming to be
" closer to the original muscle memory of pressing a single <Space>.
exec "nmap <Space><Space> " . g:bufmru_switchkey

" Set to 1 to pre-load the number marks into buffers.
" Set to 0 to avoid this pre-loading.
let g:bufmru_nummarks = 0

function! BufmruUnmap()
    " Remove undesirable mappings, keeping the bare minimum for fast buffer
    " switching without needing the press <Enter> to exit bufmru "mode".
    nunmap <Plug>bufmru....e
    nunmap <Plug>bufmru....!
    nunmap <Plug>bufmru....<Esc>
    nunmap <Plug>bufmru....y
endfunction

augroup local_bufmru
    autocmd!
    autocmd VimEnter * call BufmruUnmap()
augroup END

set textwidth=80
set colorcolumn=+0
set hlsearch
" -------------------------------------------------------------
" CtrlP
" -------------------------------------------------------------

" No default mappings.
let g:ctrlp_map = ''

" Directory mode for launching ':CtrlP' with no directory argument:
"   0 - Don't manage the working directory (Vim's CWD will be used).
"       Same as ':CtrlP $PWD'.
let g:ctrlp_working_path_mode = 0

" Set to list of marker directories used for ':CtrlPRoot'.
" A marker signifies that the containing parent directory is a "root".  Each
" marker is probed from current working directory all the way up, and if
" the marker is not found, then the next marker is checked.
let g:ctrlp_root_markers = []

" Don't open multiple files in vertical splits.  Just open them, and re-use the
" buffer already at the front.
let g:ctrlp_open_multiple_files = '1vr'

" Don't try to jump to another window or tab; instead, open the desired
" buffer in the current window.  By default, this variable is undefined, which
" is equivalent to a value of "Et":
" "E" - On <CR>, jump to open window on any tab.
" "t" - On <C-t>, jump to open window on current tab.
let g:ctrlp_switch_buffer=""

" The default of 10,000 files isn't enough, but as Jim points out, 640K
" ought to be enough for anybody :-)
let g:ctrlp_max_files = 640000

" :C [path]  ==> :CtrlP [path]
command! -n=? -com=dir C CtrlP <args>

" :CD [path]  ==> :CtrlPDir [path]
command! -n=? -com=dir CD CtrlPDir <args>

" Define prefix mapping for CtrlP plugin so that buffer-local mappings
" for CTRL-p (such as in Tagbar) will override all CtrlP plugin mappings.
nmap <C-p> <SNR>CtrlP.....

nnoremap <SNR>CtrlP.....<C-b> :<C-u>CtrlPBookmarkDir<CR>
nnoremap <SNR>CtrlP.....c     :<C-u>CtrlPChange<CR>
nnoremap <SNR>CtrlP.....C     :<C-u>CtrlPChangeAll<CR>
nnoremap <SNR>CtrlP.....<C-d> :<C-u>CtrlPDir<CR>
nnoremap <SNR>CtrlP.....<C-f> :<C-u>CtrlPCurFile<CR>
nnoremap <SNR>CtrlP.....<C-l> :<C-u>CtrlPLine<CR>
nnoremap <SNR>CtrlP.....<C-m> :<C-u>CtrlPMRU<CR>
nnoremap <SNR>CtrlP.....m     :<C-u>CtrlPMixed<CR>

" Mnemonic: "open files"
nnoremap <SNR>CtrlP.....<C-o> :<C-u>CtrlPBuffer<CR>
nnoremap <SNR>CtrlP.....<C-p> :<C-u>CtrlP<CR>
nnoremap <SNR>CtrlP.....<C-q> :<C-u>CtrlPQuickfix<CR>
nnoremap <SNR>CtrlP.....<C-r> :<C-u>CtrlPRoot<CR>
nnoremap <SNR>CtrlP.....<C-t> :<C-u>CtrlPTag<CR>
nnoremap <SNR>CtrlP.....t     :<C-u>CtrlPBufTag<CR>
nnoremap <SNR>CtrlP.....T     :<C-u>CtrlPBufTagAll<CR>
nnoremap <SNR>CtrlP.....<C-u> :<C-u>CtrlPUndo<CR>

" Reverse move and history binding pairs:
" - For consistency with other plugins that use <C-n>/<C-p> for moving around.
" - Because <C-j> is bound to the tmux prefix key, so it's best to map
"   that key to a less-used function.
let g:ctrlp_prompt_mappings = {
        \ 'PrtSelectMove("j")':   ['<C-n>', '<down>'],
        \ 'PrtSelectMove("k")':   ['<C-p>', '<up>'],
        \ 'PrtHistory(-1)':       ['<C-j>'],
        \ 'PrtHistory(1)':        ['<C-k>'],
        \ }

" Maximum height of filename window.
let g:ctrlp_max_height = 50

" Reuse the current window when opening new files.
let g:ctrlp_open_new_file = 'r'

" Symlinks:
" 0 - Do not follow symlinks.
" 1 - Follow non-looped symlinks.
" 2 - Follow all symlinks.
let g:ctrlp_follow_symlinks = 1

" An incomplete mapping should do nothing.
nnoremap <SNR>CtrlP.....      <Nop>

" Allow buffers to be hidden even if they have changes.
set hidden

" For smoother integration with typical applications that use the clipboard,
" set both "unnamed" and "unnamedplus".  This causes yanks to go to both
" the system clipboard (because of "unnamedplus") and the X11 primary selection
" (because of "unnamed"); in addition, puts use the clipboard as their default
" source (because "unnamedplus" takes priority over "unnamed" for puts).
" Disable "autoselect" mode, as that option makes it hard to create a selection
" and then overwrite it with something from the clipboard.
" Use "^=" to prepend these new settings to ensure they come before a possible
" "exclude" option that must be last.
" Note that the "unnamedplus" feature was added in Vim 7.3.74.
set clipboard-=autoselect
set clipboard^=unnamed
if has('unnamedplus')
    set clipboard^=unnamedplus
endif

" Make Y work the way I expect it to: yank to the end of the line.
nnoremap Y y$

" Shortcut for clearing CtrlP caches
nnoremap <Leader><Leader>r :<C-U>CtrlPClearAllCaches<CR>

" Allow . to work over visual ranges.
vnoremap . :normal .<CR>

" Make splits appear on the right.
set splitright

" Make line numbers appear relative to the cursor postion.
set relativenumber

"Toggle relative and normal numbering
function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunction

nnoremap <C-n> :call NumberToggle()<cr>

nmap <leader><leader>a :Ack

" Shortcuts for moving between windows.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

set background=dark
colorscheme base16-eighties

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX') && !has('nvim') " Support resizing in tmux
  set ttymouse=xterm2
endif

nmap <leader><leader>t :TagbarToggle<CR>

" Blank line below current line
nnoremap zj o<Esc>
" Blank line above current line
nnoremap zk O<Esc>

" Bells are bad
set noerrorbells

" Get rid of all the annoying window borders in gvim
set guioptions=

" Very magic regex
nnoremap / /\v
cnoremap %s/ %s/\v

set guifont=Source\ Code\ Pro\ Light

"" Disable Highlighting tabs and longlines - borrowed from jszakmeister
"
"function! CustomSetupSource()
"    call SetupSource()
"    Highlight nolonglines notabs
"endfunction
"command! -bar SetupSource call CustomSetupSource()
"
"" Same as the above, but for C.
"function! CustomSetupC()
"    call SetupC()
"    Highlight nolonglines notabs
"
"    " Cope with Doxygen style /// comments.
"    setlocal comments=s:/*,mb:\ ,e-4:*/,:///,://
"endfunction
"command! -bar SetupC call CustomSetupC()

" Replace trailing spaces with a dot and tabs with an arrow
set listchars=trail:·,precedes:«,tab:▸\ ,extends:»
set list


" Remove "rubbish" whitespace (from Andy Wokula posting).

nnoremap <silent> drw :<C-u>call DeleteRubbishWhitespace()<CR>

function! DeleteRubbishWhitespace()
    " Reduce many spaces or blank lines to one.
    let saveVirtualEdit = [&virtualedit]
    set virtualedit=
    let line = getline(".")
    if line =~ '^\s*$'
        let savePos = winsaveview()
        let saveFoldEnable = &foldenable
        setlocal nofoldenable
        normal! dvip0D
        let savePos.lnum = line(".")
        let &l:foldenable = saveFoldEnable
        call winrestview(savePos)
    elseif line[col(".")-1] =~ '\s'
        normal! zvyiw
        if @@ != " "
            normal! dviwr m[
            " m[ is just to avoid a trailing space
        endif
    endif
    let [&ve] = saveVirtualEdit
    silent! call repeat#set("drw")
endfunction

function! StripTrailingWhitespace()
    let savePos = winsaveview()
    let saveFoldEnable = &foldenable
    setlocal nofoldenable
    %substitute /\s\+$//ge
    let &l:foldenable = saveFoldEnable
    call winrestview(savePos)
endfunction
command! -bar StripTrailingWhitespace  call StripTrailingWhitespace()

nnoremap <Leader><Leader>$  :StripTrailingWhitespace<CR>

" Remap Q from useless "Ex" mode to "gq" re-formatting command.
nnoremap Q gq
xnoremap Q gq
onoremap Q gq

" Paragraph re-wrapping, similar to Emacs's Meta-Q and TextMate's Ctrl-Q.
function! RewrapParagraphExpr()
    return (&tw > 0 ? "gqip" : "vip:join\<CR>") . "$"
endfunction

function! RewrapParagraphExprVisual()
    return (&tw > 0 ? "gq"   :    ":join\<CR>") . "$"
endfunction

function! RewrapParagraphExprInsert()
    " Include undo point via CTRL-g u.
    return "\<C-g>u\<Esc>" . RewrapParagraphExpr() . "A"
endfunction

nnoremap <expr> <M-q>      RewrapParagraphExpr()
nnoremap <expr> <Leader>q  RewrapParagraphExpr()
xnoremap <expr> <M-q>      RewrapParagraphExprVisual()
xnoremap <expr> <Leader>q  RewrapParagraphExprVisual()
inoremap <expr> <M-q>      RewrapParagraphExprInsert()

" Move vertically by screen lines instead of physical lines.
" Exchange meanings for physical and screen motion keys.

" When the popup menu is visible (pumvisible() is true), the up and
" down arrows should not be mapped in order to preserve the expected
" behavior when navigating the popup menu.  See :help ins-completion-menu
" for details.

" Down
nnoremap j           gj
xnoremap j           gj
nnoremap <Down>      gj
xnoremap <Down>      gj
inoremap <silent> <Down> <C-r>=pumvisible() ? "\<lt>Down>" : "\<lt>C-o>gj"<CR>
nnoremap gj          j
xnoremap gj          j

" Up
nnoremap k           gk
xnoremap k           gk
nnoremap <Up>        gk
xnoremap <Up>        gk
inoremap <silent> <Up>   <C-r>=pumvisible() ? "\<lt>Up>" : "\<lt>C-o>gk"<CR>
nnoremap gk          k
xnoremap gk          k

" Start of line
nnoremap 0           g0
xnoremap 0           g0
nnoremap g0          0
xnoremap g0          0
nnoremap ^           g^
xnoremap ^           g^
nnoremap g^          ^
xnoremap g^          ^

" End of line
nnoremap $           g$
xnoremap $           g$
nnoremap g$          $
xnoremap g$          $

" Navigate conflict markers.
function! GotoConflictMarker(direction, beginning)
    if a:beginning
        call search('^<\{7}<\@!', a:direction ? 'W' : 'bW')
    else
        call search('^>\{7}>\@!', a:direction ? 'W' : 'bW')
    endif
endfunction

nnoremap [n :call GotoConflictMarker(0, 1)<CR>
nnoremap [N :call GotoConflictMarker(0, 0)<CR>
nnoremap ]n :call GotoConflictMarker(1, 1)<CR>
nnoremap ]N :call GotoConflictMarker(1, 0)<CR>

" Command-line editing.
" To match Bash, setup Emacs-style command-line editing keys.
" This loses some Vim functionality.  The original functionality can
" be had by pressing CTRL-o followed by the original key.  E.g., to insert
" all matching filenames (originally <C-a>), do <C-o><C-a>.
cnoremap <C-a>      <Home>
cnoremap <C-b>      <Left>
cnoremap <C-d>      <Del>
cnoremap <C-f>      <Right>
cnoremap <C-n>      <Down>
cnoremap <C-p>      <Up>
cnoremap <M-b>      <S-Left>
cnoremap <M-f>      <S-Right>

cnoremap <C-o><C-a> <C-a>
cnoremap <C-o><C-b> <C-b>
cnoremap <C-o><C-d> <C-d>
cnoremap <C-o><C-f> <C-g>
cnoremap <C-o><C-n> <C-n>
cnoremap <C-o><C-p> <C-p>

" Setup command-line completion (inside of Vim's ':' command line).
" Controlled by two options, 'wildmode' and 'wildmenu'.
" `wildmode=full` completes the full word
" `wildmode=longest` completes the longest unambiguous substring
" `wildmode=list` lists all matches when ambiguous
" When more than one mode is given, tries first mode on first keypress,
" and subsequent modes thereafter.
" `wildmode=longest,list` matches longest unambiguous, then shows list
"   of matches on next keypress if match didn't grow longer.
" If wildmenu is set, it will be used only when wildmode=full.

set wildmode=longest,list

" Ignore some Vim-related artifacts.
set wildignore+=*.swp,tags,cscope.out

" Ignore common file backup extensions.
set wildignore+=*~,*.bak

" Ignore some binary build artifacts for Unix.
set wildignore+=*.o,*.a,*.so,*.elf

" Ignore some binary build artifacts for Windows.
set wildignore+=*.obj,*.lib,*.exe,*.opt,*.ncb,*.plg,*.ilk

" Ignore some build-related directories.
set wildignore+=build,_build,export,pkgexp

" Ignore some Python artifacts.
set wildignore+=*.pyc,*.egg-info

" Ignore some Linux-kernel artifacts.
set wildignore+=*.ko,*.mod.c,*.order,modules.builtin

" Ignore some Java and Clojure-related files.
set wildignore+=*.class,classes,*.jar,.lein-*

" Ignore debug symbols on Mac OS X.
set wildignore+=*.dSYM

" -------------------------------------------------------------
" Tags
" -------------------------------------------------------------

" The semicolon gives permission to search up toward the root
" directory.  When followed by a path, the upward search terminates
" at this "stop directory"; otherwise, the search terminates at the root.
" Relative paths starting with "./" begin at Vim's current
" working directory or the directory of the currently open file.
" See :help file-searching for more details.
"
" Additional directories may be added, e.g.:
" set tags+=/usr/local/share/ctags/qt4
"
" Start at working directory or directory of currently open file
" and search upward, stopping at $HOME.  Secondly, search for a
" tags file upward from the current working directory, but stop
" at $HOME.
set tags=./tags;$HOME,tags;$HOME
" The :tjump command is more convenient than :tag because it will pop up a
" menu if and only if multiple tags match.  Exchange the default meaning
" of CTRL-] and friends to use :tjump for the more convenient keystrokes,
" and to allow the old behavior via tha "g"-prefixed less-convenient keystrokes.
" Additionally, map the mouse to use the :tjump variants.

nnoremap g<C-]>   <C-]>
xnoremap g<C-]>   <C-]>
nnoremap  <C-]>  g<C-]>
xnoremap  <C-]>  g<C-]>

" From LLVM vimrc

set softtabstop=4
set shiftwidth=4
set expandtab

" Highlight trailing whitespace and lines longer than 80 columns.
highlight LongLine ctermbg=DarkYellow guibg=DarkYellow
highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow
if v:version >= 702
  " Whitespace at the end of a line. This little dance suppresses
  " whitespace that has just been typed.
  au BufWinEnter * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
  au InsertEnter * call matchdelete(w:m1)
  au InsertEnter * let w:m2=matchadd('WhitespaceEOL', '\s\+\%#\@<!$', -1)
  au InsertLeave * call matchdelete(w:m2)
  au InsertLeave * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
else
  au BufRead,BufNewFile * syntax match LongLine /\%>80v.\+/
  au InsertEnter * syntax match WhitespaceEOL /\s\+\%#\@<!$/
  au InsertLeave * syntax match WhitespaceEOL /\s\+$/
endif

" C/C++ programming helpers
augroup csrc
  au!
  autocmd FileType *      set nocindent smartindent
  autocmd FileType c,cpp  set cindent
augroup END
" Set a few indentation parameters. See the VIM help for cinoptions-values for
" details.  These aren't absolute rules; they're just an approximation of
" common style in LLVM source.
set cinoptions=:0,g0,(0,Ws,l1
" Add and delete spaces in increments of `shiftwidth' for tabs
set smarttab

" In Makefiles, don't expand tabs to spaces, since we need the actual tabs
autocmd FileType make set noexpandtab

" Useful macros for cleaning up code to conform to LLVM coding guidelines

" Delete trailing whitespace and tabs at the end of each line
command! DeleteTrailingWs :%s/\s\+$//


