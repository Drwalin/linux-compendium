
" fix compatibility with GNU-screen:
map ^V <Home>
map ^[[4~ <End>
imap ^V <Home>
imap ^[[4~ <End>

" change default shell to fish
set shell=/bin/fish



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



" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala let b:comment_leader = '//'
  autocmd FileType cs,h,hpp,cxx,cc  let b:comment_leader = '//'
  autocmd FileType js,css           let b:comment_leader = '//'
  autocmd FileType asm,s            let b:comment_leader = ';'
  autocmd FileType sh,ruby,python   let b:comment_leader = '#'
  autocmd FileType conf,fstab       let b:comment_leader = '#'
  autocmd FileType tex              let b:comment_leader = '%'
  autocmd FileType mail             let b:comment_leader = '>'
  autocmd FileType vim              let b:comment_leader = '"'
augroup END
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR> /<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR> \=/\1/e<CR>:nohlsearch<CR>
