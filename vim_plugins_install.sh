#!usr/local/bin/bash

pathogen_folder="$HOME/.vim/autoload"
declare -A plugin1=(
    [name]='ctrlp.vim'
    [log_message]='1. Fuzzy Searching'
    [url]='https://github.com/kien/ctrlp.vim.git'
    [config_snippet]='\n" fuzzy search settings\nlet g:ctrlp_show_hidden = 1\nmap <C-p> :CtrlP<CR>\n'
    [helptag_partial]='doc'
)

declare -A plugin2=(
    [name]='nerdtree'
    [log_message]='2. File Tree Explorer'
    [url]='https://github.com/scrooloose/nerdtree.git'
    [config_snippet]='\n" file tree explorer settings\nmap <C-b> :NERDTreeToggle<CR>'
    [helptag_partial]='doc'
)

declare -A plugin3=(
    [name]='nerdcommenter'
    [log_message]='3. Auto Commenting'
    [url]='https://github.com/scrooloose/nerdcommenter.git'
    [config_snippet]='\n" nerdcommenter settings\nlet g:NERDSpaceDelims=1'
    [helptag_path]='doc'
)

declare -A plugin4=(
    [name]='vim-airline'
    [log_message]='4. Status bar'
    [url]='https://github.com/vim-airline/vim-airline'
    [config_snippet]='\n" vim-airline settings\n'
    [helptag_path]='doc'
)

declare -A plugin5=(
    [name]='auto-pairs'
    [log_message]='5. Auto Pair brackets, parens, quotes'
    [url]='https://github.com/jiangmiao/auto-pairs.git'
    [config_snippet]='\n" auto-pairs settings\n'
    [helptag_path]='doc'
)

declare -A plugin6=(
    [name]='supertab'
    [log_message]='6. Easy autocompletion'
    [url]='https://github.com/ervandew/supertab.git'
    [config_snippet]='\n" supertab settings\n'
    [helptag_path]='doc'
)

declare -A plugin7=(
    [name]='syntastic'
    [log_message]='6. Linting capabilities'
    [url]='https://github.com/vim-syntastic/syntastic.git'
    [config_snippet]='\n" syntastic settings\n'
    [helptag_path]='doc'
)

if [ -d $pathogen_folder ]
then
    config_path="$HOME/dotfiles/vimrc.plugin_config"
    rm -f $config_path && touch $config_path

    for plugin_name in ${!plugin@}; do
        declare -n plugin_obj=$plugin_name
        printf "\n%s ..\n\n" "${plugin_obj[log_message]}"
        git clone ${plugin_obj[url]} "$HOME/.vim/bundle/${plugin_obj[name]}"
        [[ -n ${plugin_obj[config_snippet]} ]] && \
            echo -e ${plugin_obj[config_snippet]} | cat >> $config_path
        [[ -n ${plugin_obj[helptag_path]} ]] && \
            vim +"helptags $HOME/.vim/bundle/${plugin_obj[name]}/${plugin_obj[helptag_path]}" +q 
    done
else
    echo 'Please install pathogen from https://github.com/tpope/vim-pathogen'
fi
