" enabling lombok with YCM:
" if the following does not work, change 'Xbootclasspath/a' to
" 'Xbootclasspath/p' and vice-versa.
" let $JAVA_TOOL_OPTIONS='-javaagent:/home/drwalin/.m2/repository/org/projectlombok/lombok/1.18.22/lombok-1.18.22.jar -Xbootclasspath/a:/home/drwalin/.m2/repository/org/projectlombok/lombok/1.18.22/lombok-1.18.22.jar'

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
" Bundle 'OmniSharp/omnisharp-vim'
" Plugin 'scrooloose/syntastic'
" Plugin 'valloric/youcompleteme'
Plugin 'ycm-core/YouCompleteMe'

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

" Use the stdio version of OmniSharp-roslyn - this is the default
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_use_mono = 1

" youcompleteme settings:
" set completeopt

" Syntastic settings:
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_extra_conf_globlist = ['/home/drwalin/.vim/bundle/*/']

" some java corrections:
" let g:EclimFileTypeValidate = 0
" let g:syntastic_java_checkers = []



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




if !has_key( g:, 'ycm_language_server' )
  let g:ycm_language_server = []
endif

let g:ycm_language_server += [
  \   {
  \     'name': 'godot',
  \     'filetypes': [ 'gdscript' ],
  \     'project_root_files': [ 'project.godot' ],
  \     'port': 6005
  \   }
  \ ]




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
inoremap <C-h> <BS>
tnoremap <C-h> <BS>
nnoremap <C-o> <Nop>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
nnoremap <C-f> <Right>
nnoremap <C-b> <Left>
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^

fixdel

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
colorscheme elflord
" colorscheme industry

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
  autocmd FileType c,cpp,java,scala let b:comment_leader = '//'
  autocmd FileType cs,h,hpp,cxx,cc  let b:comment_leader = '//'
  autocmd FileType glsl,vert,frag   let b:comment_leader = '//'
  autocmd FileType geom,tess,comp   let b:comment_leader = '//'
  autocmd FileType cuda             let b:comment_leader = '//'
  autocmd FileType css              let b:comment_leader = '//'
  autocmd FileType js,javascript    let b:comment_leader = '//'
  autocmd FileType ts,typescript    let b:comment_leader = '//'
  autocmd FileType asm,s,nasm,masm  let b:comment_leader = ';'
  autocmd FileType sh,ruby,python   let b:comment_leader = '#'
  autocmd FileType zsh              let b:comment_leader = '#'
  autocmd FileType conf,fstab       let b:comment_leader = '#'
  autocmd FileType tex              let b:comment_leader = '%'
  autocmd FileType mail             let b:comment_leader = '>'
  autocmd FileType vim              let b:comment_leader = '"'
  autocmd FileType dosbatch         let b:comment_leader = 'Rem'
augroup END
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR> /<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR> \=/\1/e<CR>:nohlsearch<CR>



" Function to create the skeleton of a header file
function! CreateClassC(name)
	1
	insert
	
#1 %Object%_HPP
#2 %Object%_HPP

class %Object% {
public:
	
	%Object%();
	~%Object%();
	
	%Object%(%Object%&& rhs) = default;
	%Object%(const %Object%& rhs) = default;
	%Object%& operator=(%Object%&& rhs) = default;
	%Object%& operator=(const %Object%& rhs) = default;
	
private:
	
};

#endif

.
	execute "%s/%Object%/" . a:name . "/g"
" 	execute "1,4s/\([a-z]\)\([A-Z]\)/\1_\2/g"
 	1,4s/\([a-z]\)\([A-Z]\)/\1_\2/g
	1,4s/[a-z]/\U&/g
	execute "1,4s/#1/#ifndef/g"
	execute "1,4s/#2/#define/g"
endfunction

function! InsertClassC(name)
	" Create the skeleton of the header file
	call CreateClassC(a:name)
endfunction

command! -nargs=1 NewClassC call InsertClassC(<args>)





" Function to create the skeleton of a header file
function! CreateClassCS(name)
	1
	insert

class %Object% {
	
	public %Object%() {
	}
	
}

.
	execute "%s/%Object%/" . a:name . "/g"
endfunction

function! InsertClassCS(name)
	" Create the skeleton of the header file
	call CreateClassCS(a:name)
endfunction

command! -nargs=1 NewClassCS call InsertClassCS(<args>)




