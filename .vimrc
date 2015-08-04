"" file name: ~/.vimrc 
"" created by Longbin_Li <beangr@163.com>
"" 2014-12-05
"" 2015-03-09
"" 2015-05-12
"" debug vim plugins use below option
"" vim test.txt --startuptime time.log

" set fileformats="unix,dos"
" set ff=unix
"" line number setting
set nu

"" the indentation setting
set tabstop=4
set shiftwidth=4
set softtabstop=4
" set cindent
" set smartindent
" set autoindent
" set expandtab

" set fillchars=vert:\ ,stl:\ ,stlnc:\ 

"" mouse function setting
" set mouse=a

"" avoid pressing Q into Ex mode
map Q <nop>

"" match and display for searching
set ignorecase
set smartcase
set incsearch
set nohlsearch
" set nowrapscan
" match parenthethese
set showmatch
set matchtime=5
set magic

set t_Co=256
set autoread

"" scroll off board below or above
set scrolloff=9
"" underline the chars in which line is more than 80 chars in a single line
" au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)
" set report=0

"" current color scheme setting
" colorscheme torte
" colorscheme morning
" colorscheme evening
" colorscheme peachpuff


"" show sursor line and highlight cusor line
set cursorline
" highlight CursorLine cterm=NONE ctermbg=LightGray ctermfg=NONE

"" Use Vim defaults instead of 100% vi compatibility
set nocompatible

"" fold enable of code sections setting
" set foldenable
"" fold method: indent/syatax/marker
" set foldmethod=indent
" set foldcolumn=0
" setlocal foldlevel=100
" set foldclose=all
"" zi to open/close all fold
"" zo/zc to open/close fold under current cursor
" nnoremap <Space> @= ((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>


"" show status information
set laststatus=2
" highlight StatusLine cterm=bold ctermfg=NONE ctermbg=NONE guifg=SlateBlue guibg=yellow
" highlight StatusLine cterm=bold ctermfg=white ctermbg=black
" highlight StatusLineNC cterm=bold ctermfg=white ctermbg=black
set statusline=[%n]\ \ %F%m%r%h\ %=%{&encoding}\ %l,%c\ %p%%\ %L\ 

syntax reset
syntax on
"" if current term's type is not xterm, then syntax off
if $TERM != 'xterm'
	" colorscheme blue
	" colorscheme darkblue
	" colorscheme default
	" colorscheme delek
	" colorscheme desert
	" colorscheme elflord
	" colorscheme evening
	" colorscheme koehler
	" colorscheme morning
	" colorscheme murphy
	" colorscheme pablo "good"
	colorscheme peachpuff "good"
	" colorscheme ron
	" colorscheme shine
	" colorscheme slate
	" colorscheme torte
	" colorscheme zellner
	" syntax off
endif


"" for buffer explorer setting
"" <leader>be   show buffer in the edit window
"" <leader>bd   close current buffer
"" <leader>bw   close current buffer and write into
let g:bufExplorerShowDirectories=1
"" show the relative path not the absolute path
let g:bufExplorerShowRelativePath=0
let g:bufExplorerSplitOutPathName=0

"" for cSyntaxAfter plugin setting
" autocmd! BufRead,BufNewFile,BufEnter *.{c,cpp,h,javascript} call CSyntaxAfter()


"" for neocomplcache setting
" let g:neocomplcache_enable_at_startup=1
" set completeopt+=longest
" let g:neocomplcache_enable_auto_select=1
" let g:neocomplcache_disable_auto_complete=1

"" for nerdcommenter setting
"" <leader>ci add/del commenter toggle
"" <leader>cs add block sexy commenter
"" <leader>cm minimal add commenter
"" <leader>cc add commenter only
"" <leader>cu uncommenter only
"" <leader>cA add commenter to the end and go to insert mode
"" <leader>ca alternate the delimiters will be used
let NERDSpaceDelims=1


"" for NERDTree setting
"" ? to show help information
" map <F2> :NERDTreeMirror<CR>
" map <F2> :NERDTreeToggle<CR>
let NERDTreeWinPos='right'
let NERDTreeShowHidden=0
let NERDChrismasTree=1
let NERDTreeWinSize=23
let NERDTreeDirArrows=1
let NERDTreeQuitOnOpen=0
let NERDTreeIgnore=['.*\.o$','.*\.ko$','.*\.gz$','.*\.bz2$','.*\.rar']
let NERDTreeShowLineNumbers=0
let NERDTreeAutoDeleteBuffer=1
let NERDTreeHighlightCursorline=1


"" for Trinity plugin setting
"" <F2> to toggle Taglist
"" <F3> to toggle SourceExplorer
"" <F5> to toggle NERDTree
"" <C-j> to go to next define location
"" <C-z> to come back from the definition
"" Ctrl+] to jump to the definition 
"" Ctrl+t to come back from the jump
" nmap <F8> :TrinityToggleAll<CR>
nmap <special> <F2> :TrinityToggleTagList<CR>
nmap <special> <F3> :TrinityToggleSourceExplorer<CR>
nmap <special> <F5> :TrinityToggleNERDTree<CR>
" nmap <special> <F3> :call g:SrcExpl_PrevDef()<CR>
nmap <C-J> :call g:SrcExpl_NextDef()<CR>
nmap <C-Z> :call g:SrcExpl_GoBack()<CR>
" nmap <C-J> <C-W>j :call g:SrcExpl_Jump()<CR>


"" close the direction key in the normal mode and insert mode
" nnoremap <up>  <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up>  <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>


"" for txt file syntax setting
filetype plugin on
filetype indent on
if !exists("autocommands_loaded")
	let autocommands_loaded = 1
	au BufEnter,BufNewFile,BufRead *.txt setlocal ft=txt
	au BufEnter,BufNewFile,BufRead *.log* setlocal ft=log
	au BufEnter,BufNewFile,BufRead *.bugreport setlocal ft=bugreport

	""" This autocommand jumps to the last known position in a file
	"""	just after opening it, please verify the permission of ~/.viminfo
	""" Or just rm ~/.viminfo use: sudo rm ~/.viminfo
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

"" for Tlist plugin setting
let Tlist_Auto_Open=0
let Tlist_Auto_Update=1
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=0
let Tlist_Max_Tag_Length=30
let Tlist_File_Fold_Auto_Close=1
let Tlist_Enable_Fold_Column = 0
let Tlist_Inc_Winwidth=1
let Tlist_Process_File_Always=1
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Sort_Type="order"
" let Tlist_Sort_Type="name"

"" search and load the tags automaticly for ctags plugin
"" use this command to generate tags file: ctags -R *
set tags=tags;
set autochdir

"" for cscope plugin setting
if has("cscope")
	"" before use please generate the cscope.out file by:
	"" cscope-indexer -r
	set csprg=/usr/bin/cscope
	"" use :cstag instead of the default :tag behavior
	"" use ":cs find g" not ":tag"
	"" cst is the condensation of cscopetag
	set cst
	"" if csto=1 <C-]> use tags file firstly, then cscope.out file
	"" we recommend tags file first when scanning C language code
	set csto=1
	"" do not display msg when add cscope.out file
	set nocsverb
	"" display the depth of matched file path 
	set cspc=6

	"" define mapleader <leader> as "\" key
	let mapleader="\\"

	"" search and add cscope.out file automaticlly
	if filereadable("cscope.out")
		cs add cscope.out
	else
   	"" search cscope.out anywhere
		let cscope_file=findfile("cscope.out",".;")
		let cscope_pre=matchstr(cscope_file,".*/")
		if !empty(cscope_file) && filereadable(cscope_file)
			exe "cs add" cscope_file cscope_pre
		endif
		set csverb

	endif

	"" map the shortcut key
	"" find symbol
	nmap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	"" find global definition
	nmap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	"" find called by this function
	nmap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>
	"" find callers
	nmap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	"" find text string
	nmap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	"" find egrep pattern
	nmap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	"" find and open file
	nmap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	"" find files #include this file
	nmap <leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

endif


