#!/usr/bin/env bash

#----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <igrigar@protonmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think  # this stuff is worth it, you can buy me a beer in return Nacho.
#----------------------------------------------------------------------------

# Last update: 10-02-17


# Basic script to install everything I consider usefull/necesary when the OS is
# freshly installed. Greater freedom of installation, taking into account
# different possible environments (such VMs), using dialog.
#==============================================================================#


#------------------------------------ DEBUG -----------------------------------#
# Force the script to end when any of the following conditions are met:
#   1.- (-e) A command is executed and it miserably fails.
#   2.- (-o) A command is executed succesfully but with novelties.
#   3.- (-u) A command tries to make use of a variable not defined beforehand.
#   4.- (-x) Show the instruction that is currently being executed.

set -eou pipefail
#------------------------------------------------------------------------------#

# `dialog` is needed so we ask if user wants to install it.

if [ "$(dpkg-query -W -f='${status}\n' dialog)" != "install ok installed" ]; then
    echo -n "Package: dialog. Is needed for the installation, do you want to install it? [Y/n] "
    read -n 1 ANSWER

    if [ "$ANSWER" == "n" ]; then
        exit
    fi
fi

# Generating the configuration of dialog in a temporary file.
DIALOGRC="/tmp/dialog"

echo -e "use_shadow = OFF\n" \
"screen_color = (CYAN,BLACK,OFF)\n" \
"title_color = (BLUE,WHITE,ON)\n" \
"use_colors = ON" >$DIALOGRC

export DIALOGRC=$DIALOGRC

# Dialog screens
INSTALL_CHECKBOX=(dialog --checklist "Which packages would you like to install?" 0 45 0)
INSTALL_OPTIONS=(
    1 "Basic packages" on
    2 "Screen" off
    3 "Tmux" off
    4 "[Un]Compression tools" off
    5 "Vlc" off
    6 "Pdftk" off
    7 "Arduino" off
    8 "Transmission" off
    9 "Latex" off
    10 "Numix icon theme" off
)
CONFIG_CHECKBOX=(dialog --checklist "Which configuration files would you like to apply?" 0 45 0)
CONFIG_OPTIONS=(
    1 "Bash" on
    2 "Vim" on
    3 "Tmux" off
)
INSTALL_SELECTION=$("${INSTALL_CHECKBOX[@]}" "${INSTALL_OPTIONS[@]}" 2>&1 >/dev/tty)
CONFIG_SELECTION=$("${CONFIG_CHECKBOX[@]}" "${CONFIG_OPTIONS[@]}" 2>&1 >/dev/tty)

if [ ! -z "$INSTALL_SELECTION" ]; then
    PASSWORD=`dialog --stdout --title "Password" --clear --insecure --passwordbox "Insert sudo password" 0 45`
fi

clear

LOG="/tmp/sys-setup.log"
touch $LOG

# Install selected packages.
for opt in $INSTALL_SELECTION; do
    case $opt in
        1) echo -n "Installing Basic packages ... "
            echo "[+] Basic Packages" >>$LOG
            echo $PASSWORD|sudo apt install -y ubuntu-restricted-extras build-essential \
                linux-headers-generic vim ssh nmap cryptsetup apg \
                deborphan ppa-purge git python-pip >>$LOG
            echo $PASSWORD|sudo dpkg --add-architecture i386 >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        2) echo -n "Installing screen ... "
            echo "[+] Screen" >>$LOG
            echo $PASSWORD|sudo apt install -y screen >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        3) echo -n "Installing tmux ... "
            echo "[+] Tmux" >>$LOG
            echo $PASSWORD|sudo apt install -y tmux >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        4) echo -n "Installing [Un]Compression tools ... "
            echo "[+] [Un]Compression tools" >>$LOG
            echo $PASSWORD|sudo apt install -y rar unace p7zip-full p7zip-rar sharutils mpack arj >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        5) echo -n "Installing vlc ... "
            echo "[+] Vlc" >>$LOG
            echo $PASSWORD|sudo apt install -y vlc >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        6) echo -n "Installing pdftk ... "
            echo "[+] Pdftk" >>$LOG
            echo $PASSWORD|sudo apt install -y pdftk >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        7) echo -n "Installing arduino ... "
            echo "[+] Arduino" >>$LOG
            echo $PASSWORD|sudo apt install -y arduino arduino-core >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        8) echo -n "Installing transmission ... "
            echo "[+] Transmission daemon" >>$LOG
            echo $PASSWORD|sudo apt install -y transmission-daemon >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        9) echo -n "Installing latex ... "
            echo "[+] Latex" >>$LOG
            echo $PASSWORD|sudo apt install -y texlive-full >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
        10) echo -n "Installing numix icon theme ... "
            echo "[+] Numix icon theme" >>$LOG
            echo $PASSWORD|sudo add-apt-repository ppa:numix/ppa
            echo $PASSWORD|sudo apt update >>/dev/null
            echo $PASSWORD|sudo apt install -y numix-gtk-theme numix-icon-theme numix-icon-theme-circle >>$LOG
            echo -e "[\e[32mDone\e[39m]"
            ;;
    esac
done


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Configure selected packages.
for opt in $CONFIG_SELECTION; do
    case $opt in
        1) echo -n "Applying Bash config ... "
            echo "[+] Bash config" >>$LOG
            if [ "$(dpkg-query -W -f='${status}\n' bash)" == "install ok installed" ]; then
                if [ -f ~/.bash_aliases ]; then # Delete current bash_aliases
                    rm ~/.bash_aliases
                fi

                if [ -f ~/.bashrc ]; then # Delete current bashrc
                    rm ~/.bashrc
                fi

                # Link the files.
                ln -s "$DIR/bash/bash_aliases" ~/.bash_aliases
                ln -s "$DIR/bash/bashrc" ~/.bashrc

                echo "Success" >>$LOG
                echo -e "[\e[32mDone\e[39m]"
            else
                echo "Package: bash. Is not installed so no config is applied." >>$LOG
                echo -e "[\e[31mError\e[39m]\n└─ Package: bash. Is not installed so no config is applied."
            fi
            ;;
        2) echo -n "Applying Vim config ... "
            echo "[+] Vim config" >>$LOG
            if [ "$(dpkg-query -W -f='${status}\n' vim)" == "install ok installed" ]; then
                if [ -f ~/.vimrc ]; then # Delete current vimrc
                    rm ~/.vimrc
                fi

                if [ -d ~/.vim ]; then # Delete current vim dir
                    rm -rf ~/.vim
                fi

                # Link the files.
                ln -s "$DIR/vim/vimrc" ~/.vimrc
                ln -s "$DIR/vim" ~/.vim

                echo "Success" >>$LOG
                echo -e "[\e[32mDone\e[39m]"
            else
                echo "Package: vim. Is not installed so no config is applied." >>$LOG
                echo -e "[\e[31mError\e[39m]\n└─ Package: vim. Is not installed so no config is applied."
            fi
            ;;
        3) echo -n "Applying Tmux config ... "
            echo "[+]  config" >>$LOG
            if [ "$(dpkg-query -W -f='${status}\n' tmux)" == "install ok installed" ]; then
                if [ -f ~/.tmux.conf ]; then # Delete current tmux config
                    rm ~/.tmux.conf
                fi

                # Link the files.
                ln -s "$DIR/tmux/tmux.conf" ~/.tmux.conf

                echo "Success" >>$LOG
                echo -e "[\e[32mDone\e[39m]"
            else
                echo "Package: tmux. Is not installed so no config is applied." >>$LOG
                echo -e "[\e[31mError\e[39m]\n└─ Package: tmux. Is not installed so no config is applied."
            fi
            ;;
    esac
done

# If it has an hypervisor it means that it is a VM!
if [ ! -z "$(dmesg | grep "Hypervisor detected")" ]; then
    echo -n "Would you like to install guest additions? [Y/n] "
    read -n 1 ANSWER

    if [ "$ANSWER" != "n" ]; then
        #install the thing!
    fi
fi

# Ask if want to see the log.
echo -n "Would you like to read the log? [y/N] "
read -n 1 ANSWER

if [ "$ANSWER" == "y" ]; then
    less $LOG
    echo ""
fi

rm $DIALOGRC $LOG
