"" ~/.vimrc is loaded on vim start-up 
"" * comment iff :help or :<command> does not give enough info
""   * confused ?  so RTFM via ':he[lp] <topic>' 
""   * use ':helpgrep <regex>' with :cn and :cp
"" * 


"" Essential Options and Behavior 
"" ------------------------------
set nocompatible
behave xterm
set mouse=a  mousemodel=extend nomousefocus
set backspace=2        " backspace over <NL> and mode-boundaries
set scrolloff=3        " always keep N lines above and below cursor
set selectmode=        " SELECT mode is a silly VISUAL mode for n00bs
set virtualedit=block,onemore  " allow sel [:space:] in block-visual mode
set nocursorline       " too distracting and often slows small-font VTs
set hlsearch           " distracting but livable with proper Xresources
set laststatus=2       " always show status line
set showtabline=2      " always show tab line
set foldignore=        " used if fdm=indent ; I prefer comment indenting
set foldcolumn=4       " reserve 3 columns for folding
set foldmethod=indent  " indent folding works with nearly every language
set nofoldenable       " don't fold by default, it's slow and confusing
set tabline=
set ttyfast            " don't wait long for escapsequences on <ESC>
set history=200        " number of commands to remember
set encoding=utf-8     " use UTF-8 for character encoding
set termencoding=utf-8 " terminal uses UTF-8 for character encoding
set splitbelow         " :sp creates new window below
set linespace=1        " pixels to pad between lines
set formatoptions=tcroq2wl

"" I cannot explain this statusline, but I love it
set statusline=%m%r%h%w%F\ [%{&ff}.%Y]\ [A=\%03.3b,H=\%02.2B]\ [%04v,%04l\ (%L)]\ [%p%%]

"" enables window 'stacking' -- CTRL+J/K for up/down ; CTRL+H/L for left/right
set wmh=0 
nnoremap <C-J> <C-W>j<C-W>_ 
nnoremap <C-K> <C-W>k<C-W>_
nnoremap <C-L> gt
nnoremap <C-H> gT


"" GUI-Conditional Options
"" -----------------------
if !has("gui_running")        " vim _bad_ opts (opts that don't redefine well) ##
  set nottybuiltin
  set shortmess=at            " :messages  -- this will show a log of all messages (t truncates)
  set t_Co=256
  colorscheme desert
  "colorscheme calmar256-dark

"" gvim opts
elseif has("gui_running")   
  set guipty
  set guitablabel=
  set lines=40 columns=120 

  "" platform-specific gui opts
  if has("gui_win32") 
    set bg=light
    colorscheme blue
    set toolbar=icons,tooltips
    set guioptions=gmrLtT
    set guifont=Consolas\ 8

  elseif has("x11")
    set toolbar=
    set guioptions=catgirLbme
    set guifontwide=unifont\ 8
    set guifont=Monospace\ 8    " this will be used as a fallback
    "set guifont=Terminus\ 8
    "set guifont=Ubuntu\ Mono\ 8
    "set guifont=Dina\ 8
    set guifont=Droid\ Sans\ Mono\ 9

  endif

endif

syntax on


"" Custom Commands  
"" ---------------
cabclear  " clear any default commands

command! -nargs=0 ReloadRC source $MYVIMRC
command! -nargs=0 SudoWrite silent write !sudo tee >/dev/null %

command! -nargs=0 TS2 setl ai et   ts=2 sw=2 sts=0 tw=78 fdm=indent fml=1
command! -nargs=0 TS4 setl ai et   ts=4 sw=4 sts=0 tw=78 fdm=indent fml=1
command! -nargs=0 TT2 setl ai noet ts=2 sw=2 sts=0 tw=78 fdm=indent fml=1
command! -nargs=0 TT4 setl ai noet ts=4 sw=4 sts=0 tw=78 fdm=indent fml=1
command! -nargs=0 TT8 setl ai noet ts=8 sw=8 sts=0 tw=78 fdm=indent fml=1


"" Look for better versions of these in ~/.vim/plugin/vsh.vim
command! -complete=shellcmd -nargs=1 Vman :silent :exe ':new +setl\ ma\ |\ :setl\ bh=wipe\ bt=nofile\ noswf\ ft=man\ fdc=0\  man\ ' . fnameescape(<f-args>) | :exe ':%!man <args>' | :0
command! -complete=shellcmd -nargs=1 Vsh :silent :exe ':new +setg\ ma\ |\ :setl\ bh=wipe\ bt=nofile\ noswf bash\ ' . fnameescape(<f-args>) | :exe ':0r !' . <q-args> | :normal '[

command! -nargs=* -complete=file Tagtcl !ctags --languages=tcl --langmap=tcl:.tcl.exp.itcl --recurse=yes <args>


"" GUI-Conditional Commands
"" ------------------------
if !has("gui_running") 
  cabbrev W W

elseif has("gui_running") " ## gui cmds / maps (avoid redundancy) ##
  nnoremap <silent> <F2> :if &go =~# 'm' <Bar> :set go-=m <Bar> :else <Bar> :set go+=m <Bar> :endif

endif

"" Plugin Configuration
let g:ycm_python_binary_path = '/usr/bin/python2'
let g:ycm_collect_identifiers_from_tags_files = 1

nnoremap <silent> <F9> :TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_width = 60
let g:tagbar_left = 1
let g:tagbar_foldlevel = 0


" vim: set ai et sw=2 sts=2 ts=2 tw=78 ft=vim:
