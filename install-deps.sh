#!/bin/bash

function install_gnu_deps(){
    dpkg -s jq
}

function install_bsd_deps(){
    [[ -z `which jq` ]] && brew install jq
    [[ -z `which gsed` ]] && brew install gsed
}

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     install_gnu_deps;;
    Darwin*)    install_bsd_deps;;
    *)          echo "UNKNOWN:${unameOut}"
esac
