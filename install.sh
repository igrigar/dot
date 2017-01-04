# Short bash script to set all the files in place. A regular Debian based OS is
# assumed.

#!/usr/bin/env bash

#==============================================================================#
#                       DEBUG AND ERROR PREVENTION
#
# We stop the script in the following cases:
#   1.- (-e) A command is executed and fails.
#   2.- (-u) A command secuence tries to use undeclared variables.
#   3.- (-x) Only for debugging purposes.

set -eou pipefail

#==============================================================================#
#                        DECLARATION OF VARIABLES

BASH_ALIAS="/bash/bash_aliases"
BASHRC="/bash/bashrc"
VIM_DIR="/vim"
VIMRC="/vim/vimrc"
TMUX="/tmux/tmux.conf"

# Root validation.
if [ $(id -u) == 0 ]; then
    echo "Not root needed so not root used. Bye :)"
    exit 0
fi

# Check if the files we are going to link existed already.
if [ -f ~/.bash_aliases ]; then
    rm ~/.bash_aliases
fi

if [ -f ~/.bashrc ]; then
    rm ~/.bashrc
fi

if [ -f ~/.vimrc ]; then
    rm ~/.vimrc
fi

if [ -f ~/.tmux.conf ]; then
    rm ~/.tmux.conf
fi

if [ -d ~/.vim ]; then
    rm -rf ~/.vim
fi

# Zelda all the things!!
# I meant Link all the things.
ln -s $(pwd)$BASH_ALIAS ~/.bash_aliases
ln -s $(pwd)$BASHRC ~/.bashrc
ln -s $(pwd)$VIM_DIR ~/.vim
ln -s $(pwd)$VIMRC ~/.vimrc
ln -s $(pwd)$TMUX  ~/.tmux.conf
