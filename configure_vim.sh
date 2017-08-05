#/!bin/bash

function log_and_exec(){
    printf "\n$1 ..\n"
    #echo $2
    eval "$2"
    printf "\nDone!\n"
}

function init_config(){
    log_message='Removing previous vim configuration'
    log_and_exec "$log_message" "rm -rf $HOME/.vim && rm -f $HOME/.vimrc"

    log_message='Setting up the vim configuration files'
    #sed cannot insert in empty files so we create one with a dummy first line
    log_and_exec "$log_message" "mkdir $HOME/.vim && echo ' ' > $HOME/.vimrc"

    log_message='Copying the static dotfiles into home directory'
    log_and_exec "$log_message" "rm -rf $HOME/dotfiles && cp -r $1 $HOME"
}

function editor_config(){
    config_text="$'\" ${3}\nlet g:${1} = \'${HOME}/dotfiles/${2}\'\nexe \'source\' g:${1}\n'"
    log_and_exec "${4}" "echo -e ${config_text} | cat >> $HOME/.vimrc"
}

function setup_vim_pathogen(){
    log_message='Setting up vim pathogen to manage plugins'
    command="mkdir -p ~/.vim/autoload ~/.vim/bundle && \
            curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
    log_and_exec "$log_message" "$command"
    
    pathogen_config_snippet="execute pathogen#infect()\nsyntax on\nfiletype plugin indent on"
    sed -i "1 i $pathogen_config_snippet" $HOME/.vimrc 
}

function install_vim_plugins(){
    log_message='Installing vim plugins'
    export -f log_and_exec
    log_and_exec "$log_message" "source $1"
}

function build_vimrc(){
    
	local config_args_path=$( echo `dirname "${BASH_SOURCE[0]}"` )'/config_args_metadata.json'
	for row in $(cat $config_args_path | jq -r '.[] | @base64'); do
		_jq() {
			echo ${row} | base64 --decode | jq -r ${1}
		}
		editor_config $(_jq '.var_name') $(_jq '.file_name') "$(_jq '.comment')" "$(_jq '.log_message')"

	done
}

init_config "$HOME/customize-vim/dotfiles" #path to the dotfiles -- change if needed
setup_vim_pathogen
install_vim_plugins "$HOME/customize-vim/vim_plugins_install.sh" #path to vim plugin setup script -- change if needed

log_message='Building the vimrc file'
log_and_exec "$log_message" "build_vimrc"

