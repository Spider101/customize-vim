#!bin/bash

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
    log_and_exec "$log_message" "mkdir $HOME/.vim && touch $HOME/.vimrc"
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
    
    pathogen_config_snippet="execute pathogen#infect()\\
                            syntax on\\
                            filetype plugin indent on
                            "
    sed -i "" "1 i \\
        $pathogen_config_snippet" $HOME/.vimrc 
}

function install_vim_plugins(){
    log_message='Installing vim plugins'
    export -f log_and_exec
    log_and_exec "$log_message" "source $HOME/vim_plugins_install.sh"
}

function build_vimrc(){
    #basic_config_args=(vimBasicConfig vimrc.basic_config 'basic config for editing' 'Basic Editor Behaviour')
    #keymap_config_args=(vimKeyMap vimrc.keymap 'basic keymap config' 'Keymap Config')
    #plugin_config_args=(vimBundleConfig vimrc.bundle_config 'config for plugins' 'Plugin Config')
}

init_config
setup_vim_pathogen
install_vim_plugins



