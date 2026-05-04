" vundle plugins setup:
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" choosen plugins:
Plugin 'neoclide/coc.nvim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype indent plugin on    " required, preferred: filetype plugin indent on
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" sudo writing to file
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" set completeopt




Plugin 'tikhomirov/vim-glsl'

" for aligning (i.e. Markdown tables (visual select then) :Tab/|
" for aligning on '=' use :Tab/=
Plugin 'godlygeek/tabular'

function AlignMarkdownTable()
	" Create the skeleton of the header file
	execute "'<,'>s/|[ -]*---[ -]*|/| --- |/ge"
	execute "'<,'>s/|[ -]*---[ -]*|[ -]*---[ -]*|/| --- | --- |/ge"
	execute "'<,'>s/|[ -]*----[ -]*|/| --- |/ge"
	execute "'<,'>s/|[ -]*----[ -]*|[ -]*---[ -]*|/| --- | --- |/ge"
	execute "'<,'>Tab/|"
	let range = [1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	for i in range
		execute       "'<,'>s/|\\( *\\)    \\(---[ -]*\\)|/|\\1----\\2|/ge"
		execute "'<,'>s/|\\([ -]*---\\)    \\( *\\)|/|\\1----\\2|/ge"
		execute      "'<,'>s/|\\(--*\\)    \\(--*\\)|/|\\1----\\2|/ge"
		
		execute       "'<,'>s/|\\( *\\) \\(---[ -]*\\)|/|\\1-\\2|/ge"
		execute "'<,'>s/|\\([ -]*---\\) \\( *\\)|/|\\1-\\2|/ge"
		execute      "'<,'>s/|\\(--*\\) \\(--*\\)|/|\\1-\\2|/ge"
	endfor
endfunction

cabbrev TabMD call AlignMarkdownTable()

function! ClangFormatFunc() range
	let [line_cursor, col_cursor] = getpos('.')[1:2]
	if a:firstline != a:lastline
		execute '%!clang-format --lines=' . a:firstline . ':' . a:lastline
	else
		execute '%!clang-format'
	endif
	call setpos('.', [0, line_cursor, col_cursor, 0])
endfunction

cabbrev Format call ClangFormatFunc()



" use default latex format or something
let g:tex_flavor = "latex"




" init :makeprg for vim guickfix list and compilation
" compilation happens in /build directory with cmake and then make program
compiler gcc
let &makeprg="cd build && cmake .. && ninja $*"
" let &makeprg="cd build && cmake .. && ninja $* || make $*"




" ignore following directories while performing vim(vimgrep) saerch
set wildignore=*/thirdparty/*,*/build/*,*/CMakeFiles/*


function! VimgrepWithHighlight(...)
	let numArgs = a:0
	let pattern = a:1
	let directories = ["**"]
	if numArgs > 1
		let directories = []
	endif
	let first = 0
	for argument in a:000
		if first == 0
			let first = 1
		else
			call add(directories, argument)
		endif
	endfor
	
	let vimgrepStringCommand = 'vimgrep ' . pattern . ' '
	for dirr in directories
		let vimgrepStringCommand = vimgrepStringCommand . dirr . ' '
	endfor
	execute vimgrepStringCommand
	
	let searchPattern = strpart(pattern, 1, strlen(pattern)-2)
	let @/ = searchPattern
	let executeRegularSearch = 'normal /'. searchPattern . "\<CR>"
	execute executeRegularSearch
endfunction

command! -nargs=+ Vimgrep call VimgrepWithHighlight(<f-args>)
cabbrev Vim Vimgrep
cabbrev vimgrep Vimgrep



" fix compatibility with GNU-screen:
map ^V <Home>
map ^[[4~ <End>
imap ^V <Home>
imap ^[[4~ <End>

" change default shell to fish
set shell=/bin/fish



" set viminfo=%,'10,/1000,:1000,n~/.viminfo


set textwidth=80
autocmd FileType txt setlocal noexpandtab



set dir=~/.vimswap
set backupdir=~/.vimswap//

autocmd FileType markdown setlocal expandtab
autocmd FileType md setlocal expandtab
set tabstop=4
set shiftwidth=4
set cindent

inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>

" compatibility with bash navigation/edition
inoremap <C-h> <BS>
tnoremap <C-h> <BS>
nnoremap <C-o> <Nop>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
nnoremap <C-b> <Left>
nnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
inoremap <C-e> <End>
inoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-a> <Home>
cnoremap <C-d> <Delete>


""""""""""""""""""""""""""""""""""""""""
""""" START coc.nvim configuration \""""
""""""""""""""""""""""""""""""""""""""""

set updatetime=500

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""
"""""" END coc.nvim configuration \"""""
""""""""""""""""""""""""""""""""""""""""




colorscheme elflord
" colorscheme industry

set nowrap
set number
set laststatus=2
set ruler
set colorcolumn=80
syntax on
syntax enable

set belloff=all

set hlsearch

set clipboard=unnamedplus
set backspace=indent,eol,start
set encoding=utf-8

set directory^=~/.vimswap/temp//

" gvim options:
set guioptions-=m  " gvim hide menu bar
set guioptions-=T  " gvim hide toolbar
set guioptions-=r  " gvim hide scrollbar
set guioptions-=R  " gvim hide scrollbar
set guioptions-=r  " gvim hide scrollbar
set guioptions-=L  " gvim hide scrollbar
set guioptions-=e  " gvim tab pages line
set guifont=DejaVu\ Sans\ Mono\ 9

nmap n /<CR>
nmap N ?<CR>

map j gj
map k gk



hi WarningMsg ctermfg=Blue
hi WarningMsg ctermbg=Yellow
hi ErrorMsg ctermfg=Blue
hi ErrorMsg ctermbg=Red 
hi Error ctermbg=Red 
hi Error ctermfg=Blue

hi Comment ctermfg=Blue
hi Visual cterm=none term=none ctermfg=Black ctermbg=DarkGreen



" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType sql              let b:comment_leader = '--'
  autocmd FileType c,cpp,java,scala let b:comment_leader = '\/\/'
  autocmd FileType cs,h,hpp,cxx,cc  let b:comment_leader = '\/\/'
  autocmd FileType glsl,vert,frag   let b:comment_leader = '\/\/'
  autocmd FileType geom,tess,comp   let b:comment_leader = '\/\/'
  autocmd FileType cuda             let b:comment_leader = '\/\/'
  autocmd FileType css              let b:comment_leader = '\/\/'
  autocmd FileType js,javascript    let b:comment_leader = '\/\/'
  autocmd FileType ts,typescript    let b:comment_leader = '\/\/'
  autocmd FileType json             let b:comment_leader = '\/\/'
  autocmd FileType asm,s,nasm,masm  let b:comment_leader = ';'
  autocmd FileType sh,ruby,python   let b:comment_leader = '#'
  autocmd FileType zsh              let b:comment_leader = '#'
  autocmd FileType conf,fstab       let b:comment_leader = '#'
  autocmd FileType cmake            let b:comment_leader = '#'
  autocmd FileType tex              let b:comment_leader = '%'
  autocmd FileType mail             let b:comment_leader = '>'
  autocmd FileType vim              let b:comment_leader = '"'
  autocmd FileType dosbatch         let b:comment_leader = 'Rem'
augroup END

function DoComment()
	let tmpSearch = @/
	set nohlsearch
	execute 's/^/'. b:comment_leader . ' /'
	let @/ = tmpSearch
	set hlsearch
endfunction
noremap <silent> ,cc :call DoComment()<CR>

function UndoComment()
	let tmpSearch = @/
	set nohlsearch
	execute 's/^\(\s*\)'.b:comment_leader.' \?/\1/e'
	let @/ = tmpSearch
	set hlsearch
endfunction
noremap <silent> ,cu :call UndoComment()<CR>







hi CPP_ASSERT ctermfg=RED guifg=RED
autocmd WinEnter    *.cpp,*.c,*.hpp,*.h,*.cxx,*.inl,*.hxx,*.hh,*.cc match CPP_ASSERT /\<assert\>/
autocmd BufWinEnter *.cpp,*.c,*.hpp,*.h,*.cxx,*.inl,*.hxx,*.hh,*.cc match CPP_ASSERT /\<assert\>/
autocmd InsertEnter *.cpp,*.c,*.hpp,*.h,*.cxx,*.inl,*.hxx,*.hh,*.cc match CPP_ASSERT /\<assert\>/
autocmd InsertLeave *.cpp,*.c,*.hpp,*.h,*.cxx,*.inl,*.hxx,*.hh,*.cc match CPP_ASSERT /\<assert\>/



if has('nvim')
	" NeoVim only features
	cabbrev E Explore
else
	" Vim only features
	fixdel
endif


