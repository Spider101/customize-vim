#!usr/local/bin/bash

pathogen_folder="$HOME/.vim/autoload"
plugins_path=$( echo `dirname "${BASH_SOURCE[0]}"`)'/plugins.json'

if [ -d $pathogen_folder ]
then
    config_path="$HOME/dotfiles/vimrc.plugin_config"
    rm -f $config_path && touch $config_path

   	for row in $(cat $plugins_path | jq -r '.[] | @base64'); do  
		_jq() {
			echo ${row} | base64 --decode | jq -r ${1}
		}
		printf "\n%s ..\n\n" "$(_jq '.log_message')"
		git clone $(_jq '.url') "$HOME/.vim/bundle/$(_jq '.name')"
		[[ -n $(_jq '.config_snippet') ]] && \
			            echo -e $(_jq '.config_snippet') | cat >> $config_path
		[[ -n $(_jq '.helptag_partial') ]] && \
				    vim +"helptags $HOME/.vim/bundle/$(_jq '.name')/$(_jq '.helptag_partial')" +q
	done  
else
    echo 'Please install pathogen from https://github.com/tpope/vim-pathogen'
fi
