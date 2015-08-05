#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive


# Create the needed directories
mkdir -p ~/src/ ~/pkgs/ ~/local/ ~/.urxvt/ext/ ~/.bin/


# Install the needed programs
sudo apt-get update
sudo apt-get -y install zsh git stow tmux ranger rxvt-unicode-256color emacs24 i3-wm i3status xfonts-terminus fonts-font-awesome python3 wget curl libcurl4-gnutls-dev
sudo apt-get -y build-dep emacs24 emacs24-common git


# Install a fresh GNU Emacs from source
cd ~/src/
git clone --depth=20 http://git.savannah.gnu.org/r/emacs.git

cd ~/src/emacs/
./autogen.sh
./configure --with-x-toolkit=lucid --prefix=$HOME/pkgs/emacs

make -j5 && make -C lisp autoloads && make install

cd ~/pkgs/
stow -v -t ~/local/ -S emacs


# Install the devel version of ranger
cd ~/src/
git clone http://github.com/hut/ranger

cd ~/src/ranger/
python3 ./setup.py install --prefix=$HOME/pkgs/ranger

cd ~/pkgs/
stow -v -t ~/local/ -S ranger


# Install the devel version of Git
cd ~/src/
git clone --depth=1 http://github.com/git/git

cd ~/src/git/
autoreconf -i
./configure --prefix=$HOME/pkgs/git

make -j5 && make install

cd ~/pkgs/
stow -v -t ~/local/ -S git


# i3 config
cd ~/src/
git clone http://github.com/vifon/i3-config

cd ~/src/i3-config/
ln -s $PWD ~/.i3
zsh -c 'ln -s $PWD/*(x.) ~/.bin'
ln -s .i3/i3status.conf ~/.i3status.conf


# urxvt config
cd ~/src/
git clone http://github.com/vifon/autocomplete-ALL-the-things
git clone http://github.com/muennich/urxvt-perls

cd ~/src/autocomplete-ALL-the-things/
ln -s $PWD/autocomplete-ALL-the-things ~/.urxvt/ext/

cd ~/src/urxvt-perls/
ln -s $PWD/keyboard-select $PWD/url-select ~/.urxvt/ext/
wget "http://gist.githubusercontent.com/Vifon/33630ea812f36152a05a/raw/8fba54d4661b3c2920a977fcaab9772da96eda45/cwd-spawn" -O ~/.urxvt/ext/cwd-spawn


# zsh config
cd ~/src/
git clone http://bitbucket.org/vifon/zsh-config

cd ~/src/zsh-config/
./install.sh -s

FZF_VERSION=0.10.2
wget https://github.com/junegunn/fzf-bin/releases/download/$FZF_VERSION/fzf-$FZF_VERSION-linux_amd64.tgz -O - | tar zvx
mv fzf-0.10.2-linux_amd64 ~/.bin/fzf

cd ~/
git clone http://github.com/vifon/zsh-image-extension ~/.zsh-image-extension
ln -sfT ~/.zsh-image-extension/zsh-image-extension ~/src/zsh-config/zplugins/zsh-image-extension


# emacs config
cd ~/src/
git clone http://bitbucket.org/vifon/emacs-config

cd ~/src/emacs-config/
./install.sh

cd ~/.emacs.d/
EMACS=$HOME/local/bin/emacs ~/.cask/bin/cask install --verbose


# General dotfiles
cd ~/src/
git clone http://bitbucket.org/vifon/dotfiles

cd ~/src/dotfiles/
./install.sh -s
