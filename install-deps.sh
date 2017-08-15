#!/bin/bash

function install_gnu_deps(){
    dpkg -s jq
}

function install_bsd_deps(){
    [[ -z `which brew` ]] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    [[ -z `which jq` ]] && brew install jq
    [[ -z `which gsed` ]] && brew install gnu-sed
    [[ -z `grep 'sed' $HOME/.bash_aliases` ]] && echo "alias sed='gsed'" >> $HOME/.bash_aliases
}

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     install_gnu_deps;;
    Darwin*)    install_bsd_deps;;
    *)          echo "UNKNOWN:${unameOut}"
esac
