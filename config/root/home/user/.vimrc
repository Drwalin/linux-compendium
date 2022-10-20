" fix compatibility with GNU-screen:
map ^V <Home>
map ^[[4~ <End>
imap ^V <Home>
imap ^[[4~ <End>

" change default shell to fish
" set shell=/bin/fish



" set viminfo=%,'10,/1000,:1000,n~/.viminfo


set dir=~/.vimswap
set backupdir=~/.vimswap//

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



hi WarningMsg ctermfg=Blue
hi WarningMsg ctermbg=Yellow
hi ErrorMsg ctermfg=Blue
hi ErrorMsg ctermbg=Red 
hi Error ctermbg=Red 
hi Error ctermfg=Blue

hi Comment ctermfg=Cyan
hi Visual cterm=none term=none ctermfg=Black ctermbg=DarkGreen



" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala let b:comment_leader = '//'
  autocmd FileType cs,h,hpp,cxx,cc  let b:comment_leader = '//'
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




