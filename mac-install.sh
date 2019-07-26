#!/bin/bash
set -e

CONFIG_DIR="$HOME/.config"

nvim_exists () {
  command -v nvim > /dev/null 2>&1;
}

install_nvim () {
  brew install neovim
}

setup_nvim() {
  if [ -d $CONFIG_DIR/nvim ] ; then
    echo -e "Found existing NeoVim configuration"
  else
    echo -e "Setting up configuration for NeoVim"
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ln -s "$HOME"/dotfiles/nvim/nvim "$CONFIG_DIR"/nvim
    if [ ! -e $CONFIG_DIR/nvim/init.vim ] ; then
      ln -nfs "$HOME"/dotfiles/nvim/nvimrc "$CONFIG_DIR"/nvim/init.vim
      ln -nfs "$HOME"/dotfiles/nvim/nvimrc "$HOME"/.nvimrc
    fi
  fi
}

setup_fish() {
  if ! brew ls --versions fish > /dev/null 2>&1; then
    brew install fish  
    curl -L https://get.oh-my.fish | fish
    echo /usr/local/bin/fish >> /etc/shells
  fi

  if [ -d $CONFIG_DIR/fish ] ; then
    echo -e "Found existing configuration for Fish"
  else
    echo -e "Setting up configuration for Fish"
    ln -s "$HOME"/dotfiles/fish "$CONFIG_DIR"/fish
  fi
}

setup_configuration() {
  echo -e "Setting up configuration"
  [ -d $CONFIG_DIR ] || mkdir $CONFIG_DIR
}

setup_tmux() {
  echo -e "Setting up configuration for TMUX"
  if ! brew ls --versions tmux > /dev/null 2>&1; then
    brew install tmux
  fi
  [ -e $HOME/.tmux.conf ] || ln -s "$HOME"/dotfiles/tmux/tmux.conf "$HOME"/.tmux.conf
}

if ! nvim_exists ; then
  install_nvim
fi
if ! brew ls --versions the_silver_searcher > /dev/null 2>&1; then
  brew install the_silver_searcher
fi

setup_configuration
setup_nvim
setup_fish
setup_tmux

