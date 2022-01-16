#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Ask for user information
echo What is your git username ?
read GIT_USERNAME
echo Do you have the apple chip (y/n) ?
read APPLE_CHIP

if [ $APPLE_CHIP == "y" ]; then
  softwareupdate --install-rosetta
fi

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add brew to the path
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $PWD/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install git.
brew install git

# Install bitwarden cli and login to it.
brew install bitwarden-cli
echo Log in to bitwarden:
bw login
bw unlock

# Install dotfiles.
brew install chezmoi
echo Setup the dotfiles
chezmoi init --apply $GIT_USERNAME
chezmoi update

# Create Projects folder.
mkdir ~/Projects

# Install applications.
brew install --cask bitwarden
brew install --cask deezer
brew install --cask docker
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
brew install --cask gimp
brew install --cask google-chrome
brew install --cask intellij-idea-ce
brew install --cask iterm2
brew install --cask postman
brew install --cask slack
brew install --cask visual-studio-code

# Install usefull cli tools.
brew install gh

# Modify the default dock.
brew install dockutil
defaults delete com.apple.dock; killall Dock
dockutil --add '/Applications/Bitwarden.app'
dockutil --add '/Applications/Deezer.app' --replacing 'Musique'
dockutil --add '/Applications/Google Chrome.app' --replacing 'Safari'
dockutil --add '/Applications/Slack.app'
dockutil --remove 'App Store'
dockutil --remove 'Contacts'
dockutil --remove 'FaceTime'
dockutil --remove 'Keynote'
dockutil --remove 'Numbers'
dockutil --remove 'Pages'
dockutil --remove 'Photos'
dockutil --remove 'Plans'
dockutil --remove 'Podcasts'
dockutil --remove 'Préférences Système'
dockutil --remove 'Rappels'
dockutil --remove 'TV'

# Install terminal utilitaries.
## Install Oh My Zsh and Powerlevel10k.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
exec zsh
## Install Oh My Zsh plugins.
brew install autojump
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
## Instal nord theme for iTerm2.
mkdir Themes
mkdir Themes/iTerm
curl https://raw.githubusercontent.com/arcticicestudio/nord-iterm2/develop/src/xml/Nord.itermcolors --output Themes/iTerm/Nord.itermcolors

